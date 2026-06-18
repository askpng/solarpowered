#!/usr/bin/bash

. /usr/lib/tuned/functions

start() {
    [ "$(/usr/bin/systemctl is-enabled scx_loader.service)" = "enabled" ] && scxctl switch -s lavd -m performance
    return 0
}

stop() {
    return 0
}

process $@
