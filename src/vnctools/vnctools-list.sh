function main() {
    vnctools::_append_history "$@"
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::parse_args $@
    ssh $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) "vncserver -list"
}
