SSH='ssh'
SSH_FLAGS='-CKf -o ConnectTimeout=2'
SSH_HEADER='--vnctools--'

function main() {
    local username=jfreden
    local hostname=fasic-beast1.fnal.gov
    echo
    echo
    # # echo "$(vncto

    vnctools::_append_history "$@"
    vnctools_connect::parse_args "$@"
    vnctools_connect::execute
}

function vnctools_connect::parse_args() {
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::add_optional_value --display AUTO
    bashargs::add_optional_value --depth 24
    bashargs::add_optional_value --localport AUTO
    bashargs::add_optional_value --remoteport AUTO
    bashargs::add_optional_value --resolution "2560x1440"
    bashargs::add_optional_value --sleep 4
    bashargs::add_optional_value --x11vnc
    bashargs::add_optional_flag --realvnc
    bashargs::add_optional_flag --screenshare
    bashargs::add_optional_flag --trace
    bashargs::parse_args "$@"
}

function vnctools_connect::execute() {
    if [[ $(bashargs::get_arg --trace) = true ]]; then
        set -x
    fi

    if [[ $(bashargs::get_arg --display) != "AUTO" ]]; then
        echo "ERROR: Only the default --display=AUTO is supported" >&2
        exit 1
    fi

    local localport=$(bashargs::get_arg --localport)
    if [[ ${localport} == "AUTO" ]]; then
        localport=$(vnctools_connect::get_local_listening_port \
                $(bashargs::get_arg --username) \
                $(bashargs::get_arg --hostname))
    fi

    local remoteport=$(bashargs::get_arg --remoteport)
    if [[ ${remoteport} == "AUTO" ]]; then
        remoteport=$(vnctools_connect::get_remote_listening_port \
                $(bashargs::get_arg --username) \
                $(bashargs::get_arg --hostname))
    fi

    clean_up () {
        for job in `jobs -p`; do
            kill ${job}
        done
    }
    trap "clean_up; exit 1" INT
    trap 'echo "ERROR: $(caller)" >&2' ERR

    local remote_vnc_session=$(vnctools_connect::get_remote_vnc_session \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname))

    if [[ -z ${remote_vnc_session} ]]; then
        vnctools_connect::auto_start_remote_vnc_sessions \
                $(bashargs::get_arg --username) \
                $(bashargs::get_arg --hostname)
        sleep $(bashargs::get_arg --sleep)

        local remote_vnc_session=$(vnctools_connect::get_remote_vnc_session \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname))
        if [[ -z ${remote_vnc_session} ]]; then
            echo "ERROR: Unable to create a new VNC session" >&2
            exit 1
        fi
    fi

    vnctools_connect::execute_remote_command ${username} ${hostname} \
            "pkill -9 -f -e vnctools-x11vnc-${remote_vnc_session}"
    sleep $(bashargs::get_arg --sleep)
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            "x11vnc \
                -tag vnctools-x11vnc-${remote_vnc_session} \
                -display :${remote_vnc_session} \
                -rfbport ${remoteport} -localhost"
                # -repeat -noshm -usepw -forever -noxdamage -snapfb -speeds dsl \
                # $(bashargs::get_arg --x11vnc)"

    sleep $(bashargs::get_arg --sleep)
    case true in
        $(bashargs::get_arg --realvnc))
            /Applications/VNC\ Viewer.app/Contents/MacOS/vncviewer localhost:${localport}
            ;;
        $(bashargs::get_arg --screenshare))
            open -W vnc://localhost:${localport}
            ;;
        *)
            open -W vnc://localhost:${localport}
            ;;
    esac
    clean_up
    wait
}


function vnctools_connect::get_local_listening_port() {
    local port=$(vnctools_connect::get_listening_port \
            "$(vnctools_connect::query_local_listening_ports $1 $2)" "${@:3}")
    if [[ -z "${port}" ]]; then
        exit 1
    else
        echo ${port}
    fi
}

function vnctools_connect::get_remote_listening_port() {
    local port=$(vnctools_connect::get_listening_port \
            "$(vnctools_connect::query_remote_listening_ports $1 $2)" "${@:3}")
    if [[ -z "${port}" ]]; then
        exit 1
    else
        echo ${port}
    fi
}

function vnctools_connect::get_listening_port() {
    if [[ $# -eq 1 ]]; then
        local min_port=1023
        local max_port=65535
        local report="$1"
    else
        local min_port="$2"
        local max_port="$3"
        local report="${@:4}"
    fi

    for (( port = ${min_port}; port <= $((max_port+1)); port++ )); do
        if ! [[ "${report}" =~ :${port} ]]; then
            break 1
        fi
    done

    if [[ ${port} -gt ${max_port} ]]; then
        echo "ERROR: No available remote port found between ${min_port} and ${max_port}" 1>&2
        exit 1
    fi
    echo ${port}
}

function vnctools_connect::get_remote_vnc_session() {
    if [[ $# -gt 2 ]]; then
        local report="${@:3}"
    else
        local report="$(vnctools_connect::query_remote_vnc_sessions $1 $2)"
    fi

    if [[ -z "${report}" ]]; then
        echo "ERROR: No available remote VNC session found." 1>&2
        exit 1
    elif [[ $(echo "${report}" | wc -l) -gt 1 ]]; then
        echo "WARNING: More than one VNC session found on remote host." 1>&2
    fi
    echo "${report}" | head -n 1 | sed 's/^://'
}

function vnctools_connect::query_local_listening_ports() {
    echo "$(lsof -iTCP -sTCP:LISTEN -n -P | awk '{print $9}')"
}

function vnctools_connect::query_remote_listening_ports() {
    local username=$1
    local hostname=$2
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            'netstat -tulpen4 | grep LISTEN | awk "{print \$4}"'
}

function vnctools_connect::query_remote_vnc_sessions() {
    local username=$1
    local hostname=$2
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            'vncserver -list | grep ^: | awk "{print \$1}"'
}

function vnctools_connect::auto_start_remote_vnc_sessions() {
    local username=$1
    local hostname=$2
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            "vncserver -localhost ${@:3}"
}

function vnctools_connect::execute_remote_command() {
    local username=$1
    local hostname=$2
    echo "$(${SSH} ${SSH_FLAGS} ${username}@${hostname} " \
            echo ${SSH_HEADER}
            ${@:3}" | grep -A500 -m1 -e ${SSH_HEADER} | tail -n+2)"
}
