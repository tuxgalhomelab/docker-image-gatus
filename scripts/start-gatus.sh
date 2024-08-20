#!/usr/bin/env bash
set -E -e -o pipefail

gatus_config="/data/gatus/config/config.yaml"

set_umask() {
    # Configure umask to allow write permissions for the group by default
    # in addition to the owner.
    umask 0002
}

setup_gatus_config() {
    echo "Checking for existing Gatus config ..."
    echo

    if [ -f "${gatus_config:?}" ]; then
        echo "Existing Gatus configuration \"${gatus_config:?}\" found"
    else
        echo "Failed to find the gatus config: \"${gatus_config}\""
        exit 1
    fi

    echo
    echo
}

start_gatus() {
    echo "Starting Gatus ..."
    echo

    export GATUS_CONFIG_PATH="$(dirname "${gatus_config:?}")"
    exec gatus
}

set_umask
setup_gatus_config
start_gatus
