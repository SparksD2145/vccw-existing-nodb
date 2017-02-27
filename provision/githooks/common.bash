#!/usr/bin/env bash

# CONFIG #
declare -a PROTECTED_BRANCHES=("master" "develop");

# Load Environment
if [ -e .env.defaults ]; then source .env.defaults; fi
if [ -e .env ]; then source .env; fi

## Runtime Variables
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,');
unset GIT_DIR

# Create directory if it doesn't exist
function create_dir () {
    if [ ! -d $1 ]; then
        mkdir $1;
    fi
}

# Remove directory if it doesn't exist
function remove_dir () {
    if [ -d $1 ]; then
        rm -rf $1;
    fi
}


# Check if branch is a member of protected branches
function isBranchProtected () {
    # assume not protected at first
    local is_protected=false;

    # check if protected
    for protected in "${PROTECTED_BRANCHES[@]}"; do
        if [ $branch == $protected ]; then
            is_protected=true;
        fi
    done;

    # Echo Result
    echo $is_protected;
}

function isVagrantRunning () {
    status=$(vagrant status --machine-readable | grep state,running | wc -l | sed 's/^ *//g');
    echo $status;
}

create_timestamp_file () {
    echo "export wp_timestamp=$(date +'%Y-%m-%d')" > $WP_DIR/$TIMESTAMP_FILE;
    echo "export $PROJECT_WP_USER"  >> $WP_DIR/$TIMESTAMP_FILE;
    echo "export $PROJECT_WP_CONTENT_TYPES" >> $WP_DIR/$TIMESTAMP_FILE;
}

function refresh_db () {
    # drop database and import database seed
    vagrant ssh --command 'wp --skip-plugins --skip-themes db drop --yes';
    vagrant ssh --command 'wp --skip-plugins --skip-themes db create';
    vagrant ssh --command 'wp --skip-plugins --skip-themes db import "/var/www/html/data.sql"';

}

function make_local () {
    # set local project url
    vagrant ssh --command "wp --skip-plugins --skip-themes option update home $PROJECT_LOCAL_URL";
    vagrant ssh --command "wp --skip-plugins --skip-themes option update siteurl $PROJECT_LOCAL_URL";
}
