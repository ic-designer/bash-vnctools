#!/usr/bin/env bash

function main() {
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::parse_args $@
    ssh $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) "vncserver -list"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    (
        set -euo pipefail
        main "$@"
    )
fi
