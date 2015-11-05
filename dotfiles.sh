#!/bin/sh
#===============================================================================
## SYNOPSIS
##    curl https://git.io/dotfiles.sh -L | sh -s GITUSER
##
## DESCRIPTION
##    clone or update your github repo https://github.com/GITUSER/dotfiles.git
##    and apply the most appropriate install strategy (dotbot|shell-script)
##
##    dotbot:
##    if there is a dotbot configuration file in your dotfiles repository
##    .dotbot.yaml|dotbot.yaml|.dotbot.json|dotbot.json
##    .install.conf.yaml|install.conf.yaml|.install.conf.json|install.conf.json
##    the dotbot repo will be cloned to the temp directory and its binary
##    will be executed with the found configuration
##
##    shell-script:
##    if there is an installation script (install.sh) it will be executed
##
## EXAMPLES
##    if your repository isn't called "dotfiles"
##    you can specify its name in the second section
##
##    curl https://git.io/dotfiles.sh -L | sh -s user/repo
##
##    if your configuration file or installation script don't match
##    the default name you can specify it in the third section
##    .yaml and .json extensions are reserved for the configuration files
##
##    curl https://git.io/dotfiles.sh -L | sh -s user/dotfiles/config.yaml
##    curl https://git.io/dotfiles.sh -L | sh -s user/repo/script.sh
##
## IMPLEMENTATION
##    author          Demajn Kaluzki
##    license         The MIT License (MIT)
#===============================================================================

#
# dotbot strategy
#
_dotbot() {
  case $1 in
    *.json|*.yaml) custom_file="${1}${IFS}";;
    *) custom_file='';;
  esac

conf_candidates="${custom_file}.dotbot.yaml
dotbot.yaml
.dotbot.json
dotbot.json
.install.conf.yaml
install.conf.yaml
.install.conf.json
install.conf.json"

  for conf_file in $conf_candidates
  do
    [ -f "$conf_file" ] && {
      echo "${IFS}found dotbot configuration${IFS}"
      tmpdir=`mktemp -d -t dotbot.XXXXXXXX`
      git clone -q --recursive https://github.com/anishathalye/dotbot ${tmpdir}
      basedir=`pwd`
      ${tmpdir}/bin/dotbot -c ${conf_file} -d ${basedir}
      return 0
    }
  done
  return 1
}

_exec() {
  git_user=$(echo $1 | cut -d '/' -f1)
  git_repo=$(echo $1 | cut -s -d '/' -f2 | sed 's/\.git$//g')
  git_repo=${git_repo:-dotfiles}
  git_file=$(echo $1 | cut -s -d '/' -f3)
  git_file=${git_file:-'install.sh'}

  echo "${IFS}try to install dotfiles from https://github.com/${git_user}/${git_repo}.git/${git_file}${IFS}"

  [ -d .git ] || {
    if [ -z "$1" ]; then
      echo "git user is not set, expects 'curl https://git.io/dotfiles.sh -L | sh -s gituser'"
      return 1;
    fi
    git clone -q --recursive https://github.com/${git_user}/${git_repo}.git .
  }

  git submodule update --init --recursive

  _dotbot $git_file || ([ -f "$git_file" ] && {
    sh $git_file
  })

  return 0
}

_exec $1