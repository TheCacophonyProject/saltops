salt_pkgrepo:
  pkgrepo.managed:
    - humanname: SaltStack
    - name: deb https://repo.saltproject.io/py3/ubuntu/18.04/amd64/3003 bionic main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltproject.io/py3/ubuntu/18.04/amd64/3003/salt-archive-keyring.gpg
    - clean_file: True
    - refresh: False

