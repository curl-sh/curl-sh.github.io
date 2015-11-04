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
curl https://git.io/dotfiles.sh -L | sh -s gituser

# will clone or update https://github.com/gituser/repo.git
curl https://git.io/dotfiles.sh -L | sh -s gituser/repo

# will update only, assumes the repo is already cloned 
curl https://git.io/dotfiles.sh -L | sh
```

## @todo

 * add support for interactive mode
 * add support for https://github.com/anishathalye/dotbot
 * add support for ansible