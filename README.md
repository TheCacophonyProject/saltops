# saltops

## Testing changes on a RaspberryPi

- Use `state-apply-test.sh`

## Testing changes on a Server

- Use `state-apply-server.sh`

## Update process

### Updating dev

The `dev` branch can just get pushed to directly.

### Updating test

- Push your latest changes to `dev`: `git push upstream dev`
- Fetch, so `upstream/dev` is current: `git fetch upstream`
- Make an `update-test` branch on your fork: `git push personal upstream/dev:refs/heads/update-test`
- On GitHub, make a PR merging `update-test` into `test`.

If GitHub reports a conflict, a hotfix on `test` needs resolving by hand:
`git checkout -b update-test upstream/test`, `git merge upstream/dev`, then push that to your fork instead.

### Updating prod

- `git fetch upstream`
- `git push personal upstream/test:refs/heads/update-prod`
- On GitHub, make a PR merging `update-prod` into `prod`, again setting the base to `prod`.
