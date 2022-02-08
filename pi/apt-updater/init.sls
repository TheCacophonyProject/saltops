#Set to 'prod' or 'test' to determine apt channel applied
{% set nodegroup = salt['cmd.run']('cat /etc/cacophony/salt-nodegroup') %}
{% if nodegroup=='test-pis' %}
  {% set channel = 'test' %}
{% elif nodegroup=='dev-pis' %}
  {% set channel = 'test' %}
{% else %}
  {% set channel = 'prod' %}
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
       - "deb [trusted=yes signed-by=/etc/cacophony/cacophony-apt-key.public] http://apt-updates.cacophony.org.nz/{{os_release}}/{{channel}}/ ./"



# apt-updater cron job
/etc/cron.d/apt-updater:
   file.managed:
     - source: salt://pi/apt-updater/apt-updater-cron

# apt-updater gpg key
/etc/cacophony/cacophony-apt-key.public:
   file.managed:
     - source: salt://pi/apt-updater/cacophony-apt-key.public

# apt-updater script
/usr/bin/apt-updater:
   file.managed:
     - source: salt://pi/apt-updater/apt-updater-script
     - mode: 755


