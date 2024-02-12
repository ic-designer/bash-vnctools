function main() {
    vnctools::_append_history "$@"
    bashargs::add_required_value --display
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::add_required_value --localport
    bashargs::add_required_value --remoteport
    bashargs::add_optional_flag --realvnc
    bashargs::add_optional_flag --screenshare
    bashargs::add_optional_value --x11vnc
    bashargs::parse_args "$@"

    clean_up () {
        for job in `jobs -p`; do
            kill ${job}
        done
    }

    trap "clean_up; exit 1" INT
    trap 'echo "ERROR: $(caller)" >&2' ERR
    ssh  -4CKf -o ConnectTimeout=2 $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) \
        $(printf 'kill -9 $(pgrep -f %s)' "vnctools-x11vnc-$(bashargs::get_arg --display)" )
    ssh  -4CKf -o ConnectTimeout=2 -L $(bashargs::get_arg --localport):localhost:$(bashargs::get_arg --remoteport) \
        $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) \
        "x11vnc \
            -tag vnctools-x11vnc-$(bashargs::get_arg --display) \
            -display :$(bashargs::get_arg --display) \
            -rfbport $(bashargs::get_arg --remoteport) -localhost \
            -noshm -usepw -once -noxdamage -snapfb -speeds dsl -repeat \
            $(bashargs::get_arg --x11vnc)"

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
