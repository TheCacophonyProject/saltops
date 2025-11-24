import os
import subprocess
import tempfile
import time


def pkg_installed_from_pypi(
    name, version, pkg_name=None, venv=None, systemd_reload=True, branch=None
):
    """Install a pip package from a PYPI release

    pkg_name
        Name of the deb package if it is different to the github repository name.

    If a new version is installed, systemd will be asked to reload it's
    configuration so that any new service files in the package are known to
    systemd.
    """
    if isinstance(version, bytes):  # Convert if byte_encoded (needed for piOS64)
        version = version.decode("utf-8", "ignore")

    if not isinstance(version, str):  # Convert if unicode string to str.
        version = version.encode("ascii", "ignore")

    # Guard against versions being converted to floats in YAML parsing.
    assert isinstance(version, str), "version must be a string"

    if pkg_name is None:
        pkg_name = name

    if venv is None:
        python_path = "python"
    else:
        python_path = "{}/python".format(venv)

    version_cmd = "import importlib.metadata; print(importlib.metadata.version('classifier-pipeline'))"
    try:
        installed_version = __salt__["cmd.run"](
            '{} -c "{}"'.format(python_path, version_cmd)
        )
        installed_version = installed_version.strip()
    except:
        installed_version = None
    if installed_version == version:
        return {
            "name": pkg_name,
            "result": True,
            "comment": "Version %s already installed." % version,
            "changes": {},
        }

    # stop it before updating, might help update faster
    __states__["service.dead"](name="thermal-recorder-py", enable=False)

    if venv is None:
        pip_path = "pip"
    else:
        pip_path = "{}/pip".format(venv)

    ret = __states__["pip.installed"](
        name=" {}=={}".format(pkg_name, version),
        bin_env=pip_path,
        refresh=False,
    )
    ret["changes"] = {pkg_name: {"old": installed_version, "new": version}}

    if systemd_reload and ret["result"] and ret["changes"] and not __opts__["test"]:
        __salt__["cmd.run"]("systemctl daemon-reload")
        ret["comment"] += " (systemd reloaded)"

    return ret


def pkg_installed_from_github(
    name, version, pkg_name=None, architecture="arm64", branch=None
):
    """Install a deb package from a Cacophony Project Github release using dpkg.
    This is a faster, more direct replacement for the pkg.installed state that
    avoids the overhead of apt. It downloads the .deb file to a temporary
    location and installs it directly with 'dpkg -i'.
    dpkg will not check manage package dependencies like apt does so make sure they are installed.
    """

    start_time = time.time()
    if isinstance(version, bytes):
        version = version.decode("utf-8", "ignore")
    if not isinstance(version, str):
        version = version.encode("ascii", "ignore")
    assert isinstance(version, str), "version must be a string"

    if pkg_name is None:
        pkg_name = name

    installed_version_cmd = f"dpkg-query --showformat='${{Version}}' --show {pkg_name}"
    installed_version_ret = __salt__["cmd.run_all"](
        installed_version_cmd, python_shell=False
    )

    installed_version = ""
    if installed_version_ret["retcode"] == 0:
        installed_version = installed_version_ret["stdout"].replace("~", "-")

    if installed_version == version:
        return {
            "name": pkg_name,
            "result": True,
            "comment": f"Version {version} already installed.",
            "changes": {},
        }

    # Make a temporary folder and set download path.
    package_tmp_dir = tempfile.mktemp()
    os.mkdir(package_tmp_dir)
    deb_path = os.path.join(package_tmp_dir, f"{pkg_name}_{version}.deb")

    # Set the default return dictionary.
    ret = {
        "name": pkg_name,
        "result": False,
        "comment": "",
        "changes": {},
    }

    try:
        # Download deb file.
        download_start_time = time.time()
        source_url = f"https://github.com/TheCacophonyProject/{name}/releases/download/v{version}/{pkg_name}_{version}_{architecture}.deb"
        download_ret = __salt__["cp.get_url"](source_url, deb_path, makedirs=True)
        download_duration = time.time() - download_start_time
        if not download_ret:
            ret["comment"] = f"Failed to download package from {source_url}"
            return ret

        # Install directly with dpkg.
        install_start_time = time.time()
        install_ret = __salt__["cmd.run_all"](f"dpkg -i {deb_path}", python_shell=False)
        install_duration = time.time() - install_start_time

        if install_ret["retcode"] != 0:
            ret["result"] = False
            ret["comment"] = "dpkg failed to install {}. Stderr: {}".format(
                deb_path, install_ret["stderr"]
            )
        else:
            ret["result"] = True
            ret["comment"] = (
                f"Package {pkg_name} version {version} installed successfully in {(time.time() - start_time):.2f}. (download: {download_duration:.2f}s, install: {install_duration:.2f}s)."
            )
            ret["changes"] = {
                "old": installed_version,
                "new": version,
            }

    finally:
        # Clean up download and temp folder
        if os.path.exists(package_tmp_dir):
            os.remove(deb_path)
        os.rmdir(package_tmp_dir)

    return ret


def init_alsa(name):
    """Ensure that the built-in audio hardware is correctly initialised."""
    if _is_audio_setup():
        return {
            "name": name,
            "result": True,
            "comment": "Audio already set up",
            "changes": {},
        }

    _remove_if_present("/var/lib/alsa/asound.state")

    # Play something (silence) to ensure the audio hardware is initialised
    # within ALSA.
    if not _play_silence():
        return {
            "name": name,
            "result": True,
            "comment": "Playing audio failed (no audio hardware present?)",
            "changes": {},
        }

    # Save the ALSA state to disk.
    subprocess.check_call(["alsactl", "store"])
    return {
        "name": name,
        "result": True,
        "comment": "ALSA state updated",
        "changes": {
            name: {
                "old": "",
                "new": "configured",
            },
        },
    }


def _is_audio_setup():
    output = str(subprocess.check_output("amixer"))
    return "Simple mixer control 'PCM',0" in output


def _remove_if_present(name):
    try:
        os.remove(name)
    except OSError:
        pass


def _play_silence():
    "Play 100ms of silence and return True if this succeeded"
    exit_code = subprocess.call(
        "sox -n -t wav - trim 0.0 0.100 | play -q -", shell=True
    )
    return exit_code == 0
