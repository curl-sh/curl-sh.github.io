#!/bin/sh

_exec() {
  git_user=$(echo $1 | cut -d '/' -f1)
  git_repo=$(echo $1 | cut -s -d '/' -f2 | sed 's/\.git$//g')
  git_repo=${git_repo:-dotfiles}
  install_script=$(echo $1 | cut -s -d '/' -f3)
  install_script=${install_script:-'install.sh'}

  echo "${IFS}try to install dotfiles from https://github.com/${git_user}/${git_repo}.git/${install_script}${IFS}"

  [ -d .git ] || {
    if [ -z "$1" ]; then
      echo "git user is not set, expects 'curl https://git.io/dotfiles.sh -L | sh -s gituser'"
      return 1;
    fi
    git clone -q --recursive https://github.com/${git_user}/${git_repo}.git .
  }

  git submodule update --init --recursive

  [ -f "$install_script" ] && {
    sh $install_script
  }
  return 0
}

_exec $1