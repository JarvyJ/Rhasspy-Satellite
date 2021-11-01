# Setting up the Digital Ocean Runner
This starts with a fresh image from Digital Ocean with the "Docker" template. The following commands will install the build tools and GitHub Actions Runner.

```bash
sudo apt update && sudo apt install -y build-essential git gcc wget curl musl-dev file perl python rsync bc patch unzip cpio pigz

adduser github # prompts for name

usermod -aG docker github
usermod -aG sudo github
sudo -iu github
export RUNNER_CFG_PAT=<REPLACE_WITH_PAT>
curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh | bash -s JarvyJ/Rhasspy-Satellite # prompts for password because uses sudo for some setup

exit # back to root's shell
delgroup github sudo # don't need to be in the sudoers group long term.
```

## Update sudoers file
Currently the SD building process requires sudo. This is setup with a sudoers file. To edit the file: `visudo -f /etc/sudoers.d/build-sd-img`, and then paste in the following:

```
User_Alias BUILDERS = github

Cmnd_Alias BUILD_CMDS = /usr/bin/make cmd/apps/satellite/buildimage, /usr/bin/make cmd/pi/common/buildimage

BUILDERS ALL=(ALL) NOPASSWD:SETENV: BUILD_CMDS
```

After that, shut it down (w/`poweroff`), create a snapshot and you're good to go. The deploy action will spin up a new droplet from the snapshot, and then use it for execution.

## Additional Notes
 * Periodically, go in and update the dependencies and save off the snapshot with the same name.
 * These machines need to be booted up at least once a month or else they'll be removed from association with the repo and the GitHub Actions setup script will have to be run again.
 * There's no real `ssh` access to these boxes. They get spun up, hooked up to GitHub Actions, and then spun down again. 
