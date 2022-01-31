# Cacophony apt-sources
/etc/apt/apt-updater-sources.list.d:
   file.directory:
     - user: root
     - name: /etc/apt/apt-updater-sources.list.d
     - group: root
     - mode: 755

{% set os_release = salt['cmd.run']('/usr/bin/lsb_release -c -s') %}

{% if os_release == 'buster' %}
/etc/apt/apt-updater-sources.list:
   file.managed:
     - contents:
       - "deb [trusted=yes] http://apt-updates.cacophony.org.nz/buster/test/ ./"
{% elif os_release == 'stretch' %}
/etc/apt/apt-updater-sources.list:
   file.managed:
     - contents:
       - "deb [trusted=yes] http://apt-updates.cacophony.org.nz/stretch/test/ ./"
{% else %}
/etc/apt/apt-updater-sources.list:
  test.fail_without_changes
{% endif %}



# apt-updater cron job
/etc/cron.d/apt-updater:
   file.managed:
     - source: salt://pi/apt-updater/apt-updater-cron
 

# apt-updater script
/usr/bin/apt-updater:
   file.managed:
     - source: salt://pi/apt-updater/apt-updater-script
     - mode: 755
   

