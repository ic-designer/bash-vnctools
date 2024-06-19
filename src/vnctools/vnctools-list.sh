function main() {
    vnctools::_append_history "$@"
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::add_optional_flag --trace
    bashargs::parse_args $@

    if [[ $(bashargs::get_arg --trace) = true ]]; then
        set -x
    fi

    vnctools_connect::_execute_remote_command \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname) \
            "find /tmp/ -user $(bashargs::get_arg --username) \
                    -type f -name '\.X*' -print 2>/dev/null \
                    | sed -n 's/.*X\(.*\)-lock.*/\1/p'"
}
