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
    - version: "0.0.41"
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
'download-model pi-v0.8 model.tar tflite 75ad09596ea5a037def91d7e40488db6be03ce137210d402567ec8d6fa8ac43e':
  cmd.run

'download-model rf-fp-v0.5 forestmodel.tar rf-fp-model 0bdef1c9b7cc6c9ff96c07683127ab3d494277307d69293ffca0867b918ca399':
  cmd.run
