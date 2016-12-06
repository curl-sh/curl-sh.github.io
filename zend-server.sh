#!/bin/sh
#===============================================================================
## SYNOPSIS
##    
## DESCRIPTION
##
## EXAMPLES
##
## IMPLEMENTATION
##    author          Demajn Kaluzki
##    license         The MIT License (MIT)
#===============================================================================
set -e

ZS_MANAGE="/usr/local/zend/bin/zs-manage"
ZS_CONF_DIR="/usr/local/zend/etc"
ZS_CONF_FILE="$ZS_CONF_DIR/zs-api.conf"

# start zend server if it is not running yet
[ $(ps -ef | grep -v grep | grep "lighttpd -m" | wc -l) -gt 0 ] || service zend-server start

# bootstrap server (is performed only once in lifetime) and store authorization info to the configuration file
if [ ! -s "$ZS_CONF_FILE" ]; then
    if [ -z "$ZS_KEY" ]; then
        ZS_KEY=`date +%s%N | sha256sum | base64 | head -c 8`
    fi
    ${ZS_LICENSE_ORDER:+"docker-user"}
    ${ZS_LICENSE_KEY:+"RUVE8341801G21E2B016FE06F679383B"}
    mkdir -p "$ZS_CONF_DIR"
    "$ZS_MANAGE" bootstrap-single-server -p "$ZS_KEY" -o "$ZS_LICENSE_ORDER" -l "$ZS_LICENSE_KEY" -a TRUE | head -n 1 > "$ZS_CONF_FILE"
fi

ZS_KEY=$(cat "$ZS_CONF_FILE" | cut -s -f 1)
ZS_HASH=$(cat "$ZS_CONF_FILE" | cut -s -f 2)

"$ZS_MANAGE" "$@" -K "$ZS_HASH" -N "$ZS_KEY"
sleep 5
"$ZS_MANAGE" restart -K "$ZS_HASH" -N "$ZS_KEY"
exit 0
