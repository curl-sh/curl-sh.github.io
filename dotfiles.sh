#!/bin/sh

[ -d .git ] || {
  if [ -z "$1" ]; then
    echo "git user is not set, expects 'curl https://git.io/dotfiles.sh -L | sh -s gituser'"
    exit 1;
  fi
  git_user=$(echo $1 | cut -d '/' -f1)
  git_repo=$(echo $1 | cut -s -d '/' -f2 | tr -d '.git')
  git_repo=${git_repo:-dotfiles}

  git clone -q --recursive https://github.com/${git_user}/${git_repo}.git .
}
git submodule update --init --recursive