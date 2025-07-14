git:
  pkg.installed: []

/etc/dbus-1/system.d/org.cacophony.thermalrecorder.conf:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/org.cacophony.thermalrecorder.conf

/etc/systemd/system/thermal-recorder-py.service:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/thermal-recorder-py.service

classifier-eqs:
  pkg.installed:
    - pkgs:
      - python3-opencv
      - libglib2.0-dev
      - libgirepository1.0-dev
      - libcairo2
      - libcairo2-dev
      - python3-dbus
      - python3-venv
      - gcc
      - pkg-config
      - python3-dev
      - gir1.2-gtk-3.0
      - libdbus-glib-1-dev
      - libdbus-1-dev
      - ffmpeg
      - python3-virtualenv
    

classifier-env:
  virtualenv.managed:
    - name:  /home/pi/.venv/classifier

#stop it before updating, might help update faster
thermal-recorder-service:
  service.dead:
    - name: thermal-recorder-py
    - enable: False

classifier-pipeline-pip:
  cacophony.pkg_installed_from_pypi:
    - name: classifier-pipeline
    - version: "0.0.25"
    - venv: /home/pi/.venv/classifier/bin/

thermal-recorder-py-service:
  service.running:
    - name: thermal-recorder-py
    - enable: True

thermal-recorder-service:
  service.dead:
    - name: thermal-recorder
    - enable: False

/usr/bin/download-model:
  file.managed:
    - source: salt://tc2/thermal-recorder-py/download-model
    - mode: 755

# When updating the version make sure to update the hash also.
'download-model pi-v0.6 8c8ad1c4505e356bf526f7b61f84e754ff95beddb86d71c59d3fff720a6692a6  inc3-tflite-15122023.tar tflite':
  cmd.run

'download-model rf-fp-v0.3 172dea33f93cc43b71b989309bfb6f4a6122221846fdf1fa09da7fd6bb2c60b9 forestmodel.tar rf-fp-model':
  cmd.run
