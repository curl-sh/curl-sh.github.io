#!/bin/sh

[ -d .git ] || {
  if [ $1 ]
  then
    github_user=$1
  else
    read -p "github user: " github_user
  fi
  git clone -q --recursive https://github.com/${github_user}/dotfiles.git .
}
git submodule update --init --recursive
