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


thermal-classifier-service:
  service.dead:
    - name: thermal-classifier
    - enable: False

thermal-postprocess-service:
  service.dead:
    - name: thermal-postprocess
    - enable: False



thermal-recorder-service:
  service.dead:
    - name: thermal-recorder
    - enable: False

classifier-pipeline-pip:
  cacophony.pkg_installed_from_pypi:
    - name: classifier-pipeline
    - version: "0.0.65"
    - venv: /home/pi/.venv/classifier/bin/


thermal-recorder-py-service:
  service.running:
    - name: thermal-recorder-py
    - enable: True
    
/usr/bin/download-model:
  file.managed:
    - source: salt://tc2/thermal-recorder-py/download-model
    - mode: 755

# When updating the version make sure to update the hash also.
'download-model pi-v1.0 model.tar tflite c04a5b376604186f01506e6c4564708ae0412d1d6a1d809147aa46f6f9051640':
  cmd.run

'download-model rf-fp-v0.5 forestmodel.tar rf-fp-model 0bdef1c9b7cc6c9ff96c07683127ab3d494277307d69293ffca0867b918ca399':
  cmd.run
