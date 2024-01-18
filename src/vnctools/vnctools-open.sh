function main() {
    bashargs::add_required_value --display
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::add_required_value --localport
    bashargs::add_optional_flag --realvnc
    bashargs::add_optional_flag --screenshare
    bashargs::parse_args $@

    clean_up () {
        for job in `jobs -p`; do
            kill ${job}
        done
    }

    trap "clean_up; exit 1" INT
    ssh  -4CKq -L $(bashargs::get_arg --localport):localhost:5900  \
        $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) \
        "x11vnc \
            -display :$(bashargs::get_arg --display) -localhost -rfbport $(bashargs::get_arg --localport) \
            -usepw -once -noxdamage -snapfb -speeds dsl -shared -repeat -forever" &

    sleep 4
    case true in
        $(bashargs::get_arg --realvnc))
            /Applications/VNC\ Viewer.app/Contents/MacOS/vncviewer localhost:$(bashargs::get_arg --localport)
            ;;
        $(bashargs::get_arg --screenshare))
            open -W vnc://localhost:$(bashargs::get_arg --localport)
            ;;
        *)
            open -W vnc://localhost:$(bashargs::get_arg --localport)
            ;;
    esac
    clean_up
    wait
}
