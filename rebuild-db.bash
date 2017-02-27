#!/usr/bin/env bash

source $(pwd)/provision/githooks/common.bash;

if [ $(isVagrantRunning) == 0 ]; then
    echo "Your vagrant host must be running!";
    exit 2;
fi

refresh_db;
make_local;
