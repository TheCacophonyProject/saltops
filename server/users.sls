{% for user, data in pillar.get('users', {}).items() %}
{{user}}:
  user.present:
    - shell: /bin/bash
    - password: {{ data.password }}
    - groups:
      - sudo
      - adm

{{user}}-keys:
  ssh_auth.present:
    - user: {{user}}
    - name: "{{data.ssh_key}}"
{% endfor %}

# /srv/pillar/users.sls should look something like this:
#users:
#  bob:
#    password: <hashed_password_for_bob>
#    ssh_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAA...
#  alice:
#    password: <hashed_password_for_alice>
#    ssh_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAA...
