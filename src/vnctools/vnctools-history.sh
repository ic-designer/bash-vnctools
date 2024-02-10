function main() {
    if [[ -f $(vnctools::_history_file) ]]; then
        cat -n $(vnctools::_history_file)
    fi
}
