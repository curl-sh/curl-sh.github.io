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

## @todo
### dotfiles.sh
```sh
# will ask for your github user
curl https://curl-sh.github.io/dotfiles.sh | sh

# will clone or update https://github.com/kaluzki/dotfiles.git
curl https://curl-sh.github.io/dotfiles.sh | sh -c kaluzki
```


 * add support for https://github.com/anishathalye/dotbot
 * add support for ansible