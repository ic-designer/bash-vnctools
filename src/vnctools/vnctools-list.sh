function main() {
    vnctools::_append_history "$@"
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::add_optional_flag --trace
    bashargs::parse_args $@

    if [[ $(bashargs::get_arg --trace) = true ]]; then
        set -x
    fi
    ssh $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) "vncserver -list"
}
