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

### dotfiles.sh
```sh
# will clone or update https://github.com/gituser/dotfiles.git
# if there is an installation script (install.sh) it will be executed
curl https://git.io/dotfiles.sh -L | sh -s gituser

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

 * add support for interactive mode
 * add support for https://github.com/anishathalye/dotbot
 * add support for ansible