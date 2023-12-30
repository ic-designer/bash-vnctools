#!/usr/bin/env bash

function main() {
    bashargs::add_required_value --display
    bashargs::add_required_value --geometry
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::parse_args $@

    ssh $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) \
        "vncserver :$(bashargs::get_arg --display) \
            -geometry $(bashargs::get_arg --geometry) \
            -depth 16 \
            -localhost
        vncserver -list"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    (
        set -euo pipefail
        main "$@"
    )
fi
