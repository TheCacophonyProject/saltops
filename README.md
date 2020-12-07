# saltops

## Update process.
### Updating dev.
The `dev` branch is updated normally through PRs.
### Updating test.
The `test` branch is updated through pulling the latest changes from `dev`:
- `git checkout -b update-test origin/test`
- `git merge origin/dev`
- Push changes to personal fork and make a PR on GitHub

### Updating prod
The `prod` branch is updated through pulling the latest changes from `test`. This should only be done when the changes in test have been tested fully:
- `git checkout -b update-prod origin/prod`
- `git merge origin/test`
- Push changes to personal fork and make a PR on GitHub


#### Version information (_Updated 7/12/2020, 4:28:45 PM_):
____
#### Branch `dev`
 * attiny-controller: 3.4.0
 * audiobait: 2.2.0
 * go-config: 1.3.1
 * device-register: 1.1.0
 * event-reporter: 3.2.0
 * management-interface: 1.6.0
 * modemd: 1.2.2
 * rtc-utils: 1.3.0
 * salt-updater: 0.1.0
 * thermal-recorder: 2.10.2
 * thermal-uploader: 2.2.0
#### Branch `test`
 * attiny-controller: 3.4.0
 * audiobait: 2.2.0
 * go-config: 1.3.1
 * device-register: 1.1.0
 * event-reporter: 3.2.0
 * management-interface: 1.6.0
 * modemd: 1.2.2
 * rtc-utils: 1.3.0
 * thermal-recorder: 2.9.2
 * thermal-uploader: 2.2.0
#### Branch `prod`
 * attiny-controller: 3.4.0
 * audiobait: 2.2.0
 * go-config: 1.3.1
 * device-register: 1.1.0
 * event-reporter: 3.2.0
 * management-interface: 1.6.0
 * modemd: 1.2.2
 * rtc-utils: 1.3.0
 * thermal-recorder: 2.9.2
 * thermal-uploader: 2.2.0
