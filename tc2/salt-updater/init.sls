#############################################################
# Ensure that salt-updater is installed, configured & running
#############################################################

salt-updater-pkg:
  cacophony.pkg_installed_from_github:
    - name: salt-updater
    - version: "0.6.1"

salt-updater:
  service.running:
    - enable: True
    # Don't include the watch section as that will tell salt to restart the service if the packages updates. 
    # Not what we want because this package is running the update itself. Service will restart when the camera is restarted.
    # //TOOD Find solution for 24/7 cameras
    #- watch:
    #  - salt-updater-pkg
