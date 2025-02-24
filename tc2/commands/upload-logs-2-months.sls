upload_logs_2_months:
  cmd.run:
    - name: |
        two_months_ago=$(date -d '2 months ago' +%Y-%m-%d)
        log_file="/tmp/journalctl-logs-last-2-months.log"
        journalctl --since "$two_months_ago" > "$log_file"
        gzip -f "$log_file"
        salt-call cp.push "$log_file.gz"
    - shell: /bin/bash
