#!/bin/sh
#===============================================================================
## SYNOPSIS
##    curl https://git.io/dotfiles.sh -L | sh -s GITUSER
##
## DESCRIPTION
##    clone or update your github repo https://github.com/GITUSER/dotfiles.git
##    and apply the most appropriate install strategy (shell-script|dotbot)
##
##    shell-script:
##    if there is an installation script (install.sh) it will be executed
##
##    dotbot:
##    if there is a dotbot configuration file in your dotfiles repository
##    .dotbot.yaml|dotbot.yaml|.dotbot.json|dotbot.json
##    .install.conf.yaml|install.conf.yaml|.install.conf.json|install.conf.json
##    the dotbot repo will be cloned to the temp directory and its binary
##    will be executed with the found configuration
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

##
# DOTBOT strategy
##
_dotbot() {
  case $1 in
    *.json|*.yaml) conf_candidates="${1}";;
               "") conf_candidates=".dotbot.yaml dotbot.yaml .dotbot.json dotbot.json .install.conf.yaml install.conf.yaml .install.conf.json install.conf.json";;
                *) conf_candidates="";;
  esac

  for conf_file in $conf_candidates
  do
    [ -f "$conf_file" ] && {
      echo "found dotbot configuration file ${conf_file}${IFS}"
      tmpdir=`mktemp -d -t dotbot.XXXXXXXX`
      git clone -q --recursive https://github.com/anishathalye/dotbot ${tmpdir}
      basedir=`pwd`
      ${tmpdir}/bin/dotbot -c ${conf_file} -d ${basedir}
      return 0
    }
  done
  return 1
}

##
# MAIN function
# parse cli parameters and delegate to different strategies
##
_main() {
  git_user=$(echo $1 | cut -d '/' -f1)
  git_repo=$(echo $1 | cut -s -d '/' -f2 | sed 's/\.git$//g')
  git_repo=${git_repo:-dotfiles}
  git_file=$(echo $1 | cut -s -d '/' -f3)

  echo "${IFS}try to install dotfiles from https://github.com/${git_user}/${git_repo}.git/${git_file}${IFS}"

  [ -d ~/${git_repo} ] || {
    mkdir -p ~/${git_repo}
  }
  cd ~/${git_repo}

  [ -d .git ] || {
    if [ -z "$1" ]; then
      echo "git user is not set, expects 'curl https://git.io/dotfiles.sh -L | sh -s gituser'"
      return 1;
    fi
    git clone -q --recursive https://github.com/${git_user}/${git_repo}.git .
  }
  git submodule update --init --recursive

  # if there is a default install script, execute it and stop
  [ "${git_file}" = "install.sh" -o "${git_file}" = "" -a -f "install.sh" ] && {
    echo "found default installation script install.sh${IFS}"
    sh install.sh
    return 0
  }

  [ $# -gt 0 ] && shift

  _dotbot "${git_file}${@}" || ([ -f "${git_file}" ] && {
    echo "found installation script ${git_file}${IFS}"
    sh "${git_file}"
  })
  return 0
}

_main $@