#!/usr/bin/env bash
set -E -e -o pipefail

gatus_config_dir="/data/gatus/config"

set_umask() {
    # Configure umask to allow write permissions for the group by default
    # in addition to the owner.
    umask 0002
}

validate_prereqs() {
    if [ $(id -u) -ne 0 ]; then
        echo "Cannot start this container as non-root!"
        echo "Ability to switch user to gatus requires launching as root!"
        echo "Need to run this container as root, however running as ${USER:?} [$(id -a)]"
        exit 1
    fi
}

start_gatus() {
    echo "Starting Gatus as user gatus ..."
    echo

    export GATUS_CONFIG_PATH="${gatus_config_dir:?}"
    exec capsh \
        --keep=1 \
        --user=gatus \
        --inh=cap_net_raw \
        --addamb=cap_net_raw \
        -- \
        -c gatus
}

set_umask
validate_prereqs
start_gatus
