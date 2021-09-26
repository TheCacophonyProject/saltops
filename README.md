# saltops

## Testing changes on a RaspberryPi
- Use `state-apply-test.sh`
## Testing changes on a Server
- Use `state-apply-server.sh`

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


#### Version information (_Updated 25/6/2021, 4:46:56 PM_):
____
#### Branch `prod`
 * attiny-controller: 3.5.0
 * audiobait: 3.0.1
 * go-config: 1.3.1
 * device-register: 1.3.0
 * event-reporter: 3.3.0
 * management-interface: 1.9.0
 * modemd: 1.2.2
 * rtc-utils: 1.3.0
 * salt-updater: 0.4.0
 * thermal-recorder: 2.13.0
 * thermal-uploader: 2.2.0

[Release notes](https://docs.cacophony.org.nz/home/release-notes-2020)
#### Branch `test`
 * attiny-controller: 3.5.0
 * audiobait: 3.0.1
 * go-config: 1.3.1
 * device-register: 1.3.0
 * event-reporter: 3.3.0
 * management-interface: 1.9.0
 * modemd: 1.2.2
 * rtc-utils: 1.3.0
 * salt-updater: 0.4.0
 * thermal-recorder: 2.13.0
 * thermal-uploader: 2.2.0
#### Branch `dev`
 * attiny-controller: 3.5.0
 * audiobait: 3.0.1
 * go-config: 1.6.4
 * device-register: 1.4.0
 * event-reporter: 3.3.0
 * management-interface: 1.9.0
 * modemd: 1.2.3
 * rtc-utils: 1.3.0
 * salt-updater: 0.4.0
 * thermal-recorder: 2.14.0
 * thermal-uploader: 2.3.0

[Release notes](https://docs.cacophony.org.nz/home/release-notes-2)
