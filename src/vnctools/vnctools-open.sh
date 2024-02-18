function main() {
    vnctools::_append_history "$@"
    vnctools_open::parse_args "$@"
    vnctools_open::execute
}

function vnctools_open::parse_args() {
    bashargs::add_required_value --display
    bashargs::add_required_value --username
    bashargs::add_required_value --hostname
    bashargs::add_optional_value --localport 5900
    bashargs::add_optional_value --remoteport 5900
    bashargs::add_optional_flag --realvnc
    bashargs::add_optional_flag --screenshare
    bashargs::add_optional_value --sleep 4
    bashargs::add_optional_value --x11vnc
    bashargs::add_optional_flag --trace
    bashargs::parse_args "$@"
}

function vnctools_open::execute() {
    if [[ $(bashargs::get_arg --trace) = true ]]; then
        set -x
    fi

    clean_up () {
        for job in `jobs -p`; do
            kill ${job}
        done
    }

    trap "clean_up; exit 1" INT
    trap 'echo "ERROR: $(caller)" >&2' ERR
    ssh  -CKf -o ConnectTimeout=2 $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) \
        $(printf 'kill -9 $(pgrep -f %s)' "vnctools-x11vnc-$(bashargs::get_arg --display)" )
    sleep $(bashargs::get_arg --sleep)
    ssh  -CKf -o ConnectTimeout=2 -L $(bashargs::get_arg --localport):localhost:$(bashargs::get_arg --remoteport) \
        $(bashargs::get_arg --username)@$(bashargs::get_arg --hostname) \
        "x11vnc \
            -tag vnctools-x11vnc-$(bashargs::get_arg --display) \
            -display :$(bashargs::get_arg --display) \
            -rfbport $(bashargs::get_arg --remoteport) -localhost \
            -noshm -usepw -forever -noxdamage -snapfb -speeds dsl \
            $(bashargs::get_arg --x11vnc)"

    sleep $(bashargs::get_arg --sleep)
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
