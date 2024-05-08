import os
import subprocess


def pkg_installed_from_pypi(
    name, version, pkg_name=None, venv=None, systemd_reload=True
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

    version_cmd = "from pip._vendor import pkg_resources; print(pkg_resources.get_distribution('classifier-pipeline').version)"
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

    if venv is None:
        pip_path = "pip"
    else:
        pip_path = "{}/pip".format(venv)

    ret = __states__["pip.installed"](
        name=" {}=={}".format(pkg_name, version),
        bin_env=pip_path,
        refresh=False,
    )

    if systemd_reload and ret["result"] and ret["changes"] and not __opts__["test"]:
        __salt__["cmd.run"]("systemctl daemon-reload")
        ret["comment"] += " (systemd reloaded)"

    return ret


def pkg_installed_from_github(
    name, version, pkg_name=None, systemd_reload=True, architecture="arm"
):
    """Install a deb package from a Cacophony Project Github release if it
    isn't installed on the system already. Currently only ARM packages are
    installed.

    pkg_name
        Name of the deb package if it is different to the github repository name.

    If a new version is installed, systemd will be asked to reload it's
    configuration so that any new service files in the package are known to
    systemd.
    """

    if isinstance(version, str):  # Convert if unicode string to str.
        version = version.encode("ascii", "ignore")

    # Guard against versions being converted to floats in YAML parsing.
    assert isinstance(version, str), "version must be a string"

    if pkg_name is None:
        pkg_name = name
    installed_version = __salt__["pkg.version"](pkg_name).replace(
        "~", "-"
    )  # pkg.version returns '~' instead of '-' in packages versions
    if installed_version == version:
        return {
            "name": pkg_name,
            "result": True,
            "comment": "Version %s already installed." % version,
            "changes": {},
        }
    source_url = "https://github.com/TheCacophonyProject/{name}/releases/download/v{version}/{pkg_name}_{version}_{architecture}.deb".format(
        name=name,
        pkg_name=pkg_name,
        version=version,
        architecture=architecture,
    )
    ret = __states__["pkg.installed"](
        name=name,
        sources=[{pkg_name: source_url}],
        refresh=False,
    )

    if systemd_reload and ret["result"] and ret["changes"] and not __opts__["test"]:
        __salt__["cmd.run"]("systemctl daemon-reload")
        ret["comment"] += " (systemd reloaded)"

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
