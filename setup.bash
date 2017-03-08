#!/usr/bin/env bash

set -e;

source ./provision/githooks/common.bash

if [ ! -L $(pwd)/.git/hooks/common.bash ]; then
    # Remove sample hooks
    if [ -e $(pwd)/.git/hooks/pre-push.sample ]; then
        rm $(pwd)/.git/hooks/*.sample;
    fi

    # Add our hooks
    for hook in $(pwd)/provision/githooks/*; do
        if [ -e "$(pwd)/.git/hooks/$(basename $hook)" ]; then
            rm "$(pwd)/.git/hooks/$(basename $hook)";
        fi
        ln -s $hook "$(pwd)/.git/hooks/$(basename $hook)";
        chmod u+x "$(pwd)/.git/hooks/$(basename $hook)";
    done;
fi

# Add provisioning file
if [ ! -e $(pwd)/provision-post.sh ]; then
    touch $(pwd)/provision-post.sh;
    echo "set -ex" >> $(pwd)/provision-post.sh;
    echo "declare siteurl=$PROJECT_LOCAL_URL" >> $(pwd)/provision-post.sh;
    echo "/usr/local/bin/wp --path=/var/www/html --skip-themes --skip-plugins option update home $PROJECT_LOCAL_URL" >> $(pwd)/provision-post.sh;
    echo "/usr/local/bin/wp --path=/var/www/html --skip-themes --skip-plugins option update siteurl $PROJECT_LOCAL_URL" >> $(pwd)/provision-post.sh;
    chmod u+x $(pwd)/provision-post.sh;
fi
