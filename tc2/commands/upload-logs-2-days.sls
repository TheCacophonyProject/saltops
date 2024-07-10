upload_logs_2_days:
  cmd.run:
    - name: |
        two_days_ago=$(date -d '2 days ago' +%Y-%m-%d)
        log_file="/tmp/journalctl-logs-last-2-days.log"
        journalctl --since "$two_days_ago" > "$log_file"
        gzip -f "$log_file"
        salt-call cp.push "$log_file.gz"
    - shell: /bin/bash
