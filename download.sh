#!/bin/sh
#===============================================================================
## SYNOPSIS
##    download.sh url-to-archive path-to-local-directory
##
## DESCRIPTION
##
## EXAMPLES
##
## download.sh http://url/lib.1.0.tar.bz2 /home/user/libs/lib/1.0
##
## IMPLEMENTATION
##    author          Demajn Kaluzki
##    license         The MIT License (MIT)
#===============================================================================

##
# MAIN function
##
_main() {
    temp_dir=`mktemp -d /tmp/download-XXXXX`
    cd "$temp_dir"
    curl -o archive -sL "$1"
    mime_type=`file -b --mime-type archive`
    case "$mime_type" in
        "application/gzip") tar xfz archive
        ;;
        "application/x-bzip2") tar xfj archive
        ;;
        "application/x-tar") tar xf archive
        ;;
        "application/zip") unzip archive
        ;;
    esac
    rm -f archive
    cd *
    mkdir -p "$2"
    mv $(ls -A) "$2"
    rm -rf "$temp_dir"
    return 0
}

_main $@
exit 0
