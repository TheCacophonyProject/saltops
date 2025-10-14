{% from "tc2/rtl8821au/map.jinja" import rtl8821au with context %}
{% set device_present = salt['cacophony.has_usb_device'](rtl8821au['device_ids']) %}
{% set install_marker = rtl8821au['install_marker'] %}
{% set already_installed = salt['file.file_exists'](install_marker) %}
{% set should_install = rtl8821au['auto_update'] or not already_installed %}
{% set install_command = "./install-driver.sh" %}
{% if rtl8821au['install_args'] %}
  {% set install_command = install_command + " " + " ".join(rtl8821au['install_args']) %}
{% endif %}

{% if device_present %}

{% if rtl8821au['packages'] %}
rtl8821au-deps:
  pkg.installed:
    - pkgs: {{ rtl8821au['packages'] }}
{% endif %}

{% if should_install %}
rtl8821au-source:
  git.latest:
    - name: {{ rtl8821au['repo'] }}
    - target: {{ rtl8821au['source_dir'] }}
    - depth: 1
    - rev: {{ rtl8821au['branch'] }}
    - require:
{% if rtl8821au['packages'] %}
      - pkg: rtl8821au-deps
{% endif %}
    - user: root
{% if not rtl8821au['auto_update'] %}
    - unless: test -f "{{ install_marker }}"
{% endif %}

rtl8821au-install:
  cmd.run:
    - name: {{ install_command }}
    - cwd: {{ rtl8821au['source_dir'] }}
    - unless: modinfo 8821au
    - require:
      - git: rtl8821au-source

rtl8821au-reinstall:
  cmd.run:
    - name: {{ install_command }}
    - cwd: {{ rtl8821au['source_dir'] }}
    - onlyif: modinfo 8821au
    - onchanges:
      - git: rtl8821au-source
    - require:
      - git: rtl8821au-source

rtl8821au-marker:
  file.managed:
    - name: {{ install_marker }}
    - contents: installed
    - makedirs: True
    - onlyif: modinfo 8821au
    - require:
      - git: rtl8821au-source
    - unless: test -f "{{ install_marker }}"
{% else %}
rtl8821au-installed:
  test.nop:
    - name: rtl8821au
    - comment: Driver already installed ({{ install_marker }})
{% endif %}

rtl8821au-modprobe-options:
  file.line:
    - name: /etc/modprobe.d/8821au.conf
    - mode: replace
    - match: ^options 8821au
    - content: options 8821au rtw_led_ctrl=1 rtw_vht_enable=2 rtw_power_mgnt=0 rtw_dfs_region_domain=3
    - onlyif: test -f /etc/modprobe.d/8821au.conf
{% if should_install %}
    - require:
      - cmd: rtl8821au-install
{% endif %}

{% else %}
rtl8821au-not-required:
  test.nop:
    - name: rtl8821au
    - comment: Driver not installed. device_present={{ device_present }}
{% endif %}
