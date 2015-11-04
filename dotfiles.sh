#!/bin/sh

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