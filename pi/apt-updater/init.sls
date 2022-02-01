#Set to 'prod' or 'test' to determine apt channel applied
{% set nodegroup = salt['cmd.run']('cat /etc/cacophony/salt-nodegroup') %}
{% if nodegroup=='prod-pis' %}
  {% set channel = 'prod' %}
{% else %}
  {% set channel = 'test' %}
{% endif %}

{% set os_release = salt['cmd.run']('/usr/bin/lsb_release -c -s') %}

# Cacophony apt-sources
/etc/apt/apt-updater-sources.list.d:
   file.directory:
     - user: root
     - name: /etc/apt/apt-updater-sources.list.d
     - group: root
     - mode: 755

/etc/apt/apt-updater-sources.list:
   file.managed:
     - contents:
       - "deb [trusted=yes] http://apt-updates.cacophony.org.nz/{{os_release}}/{{channel}}/ ./"



# apt-updater cron job
/etc/cron.d/apt-updater:
   file.managed:
     - source: salt://pi/apt-updater/apt-updater-cron


# apt-updater script
/usr/bin/apt-updater:
   file.managed:
     - source: salt://pi/apt-updater/apt-updater-script
     - mode: 755


