#!/bin/bash
# vim: set foldmethod=marker:

# DOCKER="🐳 "
DOCKER=""

timeout 2s docker ps -q 1> /dev/null

if [[ $? != 0 ]]; then
    echo "#[fg=red]${DOCKER}-#[fg=default]"
    exit 0
fi

echo "#[fg=green]${DOCKER}+#[fg=default]"
