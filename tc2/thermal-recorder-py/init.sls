git:
  pkg.installed: []

/etc/dbus-1/system.d/org.cacophony.thermalrecorder.conf:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/org.cacophony.thermalrecorder.conf

/etc/systemd/system/thermal-recorder-py.service:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/thermal-recorder-py.service

/etc/systemd/system/thermal-classifier.service:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/thermal-classifier.service

/etc/systemd/system/thermal-postprocess.service:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/thermal-postprocess.service

/etc/systemd/system/thermal-dbuslistener.service:
   file.managed:
     - source: salt://tc2/thermal-recorder-py/thermal-dbuslistener.service

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

classifier-pipeline-pip:
  cacophony.pkg_installed_from_pypi:
    - name: classifier-pipeline
    - version: "0.0.32"
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
'download-model pi-v0.7 effv2b3-202509.tar tflite ff2ed9aed0cea66c79c4813447eedc1eb6ed92d832a575de3b5d6c7a062a93ae':
  cmd.run

'download-model rf-fp-v0.4 forestmodel.tar rf-fp-model fceacd8729f661ef438e9dea12221ccddb531a4d7e6c375c1b4c6224b841b33b':
  cmd.run
