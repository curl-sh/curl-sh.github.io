# http://git.io/curl-sh

Shell scripts as services from curl-sh.github.io

## Common use
```sh
curl https://curl-sh.github.io/*.sh | sh
```
or

```sh
curl https://git.io/*.sh -L | sh
```

### curl https://git.io/dotfiles.sh -L | sh -s gituser

```sh
# will clone or update https://github.com/gituser/dotfiles.git
# and apply the most appropriate install strategy (dotbot|shell-script)
#
# dotbot:
# if there is a dotbot configuration file in your dotfiles repository
#  .dotbot.yaml|dotbot.yaml|.dotbot.json|dotbot.json
#  .install.conf.yaml|install.conf.yaml|.install.conf.json|install.conf.json
# the dotbot repo will be cloned to the temp directory and its binary
# will be executed with the found configuration
#
# shell-script:
# if there is an installation script (install.sh) it will be executed

# if your repository is named not "dotfiles"
# you can specify it in the second section
curl https://git.io/dotfiles.sh -L | sh -s gituser/custom-repo

# if your installation script is named not "install.sh"
# you can specify it in the third section
curl https://git.io/dotfiles.sh -L | sh -s gituser/dotfiles/custom-script.sh

# will update only, assumes the repo is already cloned
curl https://git.io/dotfiles.sh -L | sh
```

## @todo

 * add support for https://github.com/anishathalye/dotbot (in progress)
 * add support for interactive mode
 * add support for ansible