upload_logs_2_weeks:
  cmd.run:
    - name: |
        two_weeks_ago=$(date -d '2 weeks ago' +%Y-%m-%d)
        log_file="/tmp/journalctl-logs-last-2-weeks.log"
        journalctl --since "$two_weeks_ago" > "$log_file"
        gzip -f "$log_file"
        salt-call cp.push "$log_file.gz"
    - shell: /bin/bash
