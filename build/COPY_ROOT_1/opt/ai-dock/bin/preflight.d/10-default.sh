#!/bin/false
# This file will be sourced in init.sh

function preflight_main() {
    preflight_update_reForge
    printf "%s" "${FORGE_ARGS}" > /etc/forge_args.conf
}

function preflight_update_reForge() {
    if [[ ${AUTO_UPDATE,,} == "true" ]]; then
        /opt/ai-dock/bin/update-reForge.sh
    else
        printf "Skipping auto update (AUTO_UPDATE != true)"
    fi
}

preflight_main "$@"