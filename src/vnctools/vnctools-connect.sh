SSH='ssh'
SSH_FLAGS='-CKTq -o ConnectTimeout=2'
SSH_HEADER='--vnctools--'

PORT_MIN=1024
PORT_MAX=65535


function main() {
    (
        vnctools::_append_history "$@"
        vnctools_connect::parse_args "$@"
        vnctools_connect::execute
    )
}

function vnctools_connect::parse_args() {
    bashargs::add_required_value --hostname
    bashargs::add_required_value --username
    bashargs::add_optional_value --display AUTO
    bashargs::add_optional_value --depth 16
    bashargs::add_optional_value --localport AUTO
    bashargs::add_optional_value --remoteport AUTO
    bashargs::add_optional_value --resolution AUTO
    bashargs::add_optional_value --sleep 4
    bashargs::add_optional_value --x11vnc
    bashargs::add_optional_flag --realvnc
    bashargs::add_optional_flag --screenshare
    bashargs::add_optional_flag --trace
    bashargs::parse_args "$@"
}


function vnctools_connect::execute() {
    trap 'vnctools_connect::clean_up; exit 1' INT TERM
    trap 'vnctools_connect::clean_up; echo "ERROR: $(caller)" >&2' ERR

    if [[ $(bashargs::get_arg --trace) = true ]]; then
        set -xT
    fi

    if [[ $(bashargs::get_arg --display) != "AUTO" ]]; then
        echo "ERROR: Only the default --display=AUTO is supported" >&2
        exit 1
    fi

    local localport=$(bashargs::get_arg --localport)
    if [[ ${localport} == "AUTO" ]]; then
        echo -n "INFO: Autodetecting local listenting port...."
        localport=$(vnctools_connect::find_local_listening_port \
                $(bashargs::get_arg --username) \
                $(bashargs::get_arg --hostname))
        echo -e "${localport}"
    fi

    local remoteport=$(bashargs::get_arg --remoteport)
    if [[ ${remoteport} == "AUTO" ]]; then
        echo -n "INFO: Autodetecting remote listenting port...."
        remoteport=$(vnctools_connect::find_remote_listening_port \
                $(bashargs::get_arg --username) \
                $(bashargs::get_arg --hostname))
        echo -e "${remoteport}"
    fi

    local remote_vnc_session=$(vnctools_connect::get_remote_vnc_session \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname))
    if [[ -z ${remote_vnc_session} ]]; then
        vnctools_connect::new_remote_vnc_session \
                $(bashargs::get_arg --username) \
                $(bashargs::get_arg --hostname)
        local remote_vnc_session=$(vnctools_connect::get_remote_vnc_session \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname))
        if [[ -z ${remote_vnc_session} ]]; then
            echo "ERROR: Unable to create a new VNC session" >&2
            exit 1
        fi
    fi

    vnctools_connect::execute_remote_command \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname) \
            "pkill -9 -f -e vnctools-x11vnc-${remote_vnc_session}" 2>&1 >/dev/null
    vnctools_connect::open_remote_vnc_session \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname) \
            ${remote_vnc_session} \
            ${localport} \
            ${remoteport} \
            $(bashargs::get_arg --x11vnc)
    sleep $(bashargs::get_arg --sleep)

    if [[ $(bashargs::get_arg --resolution) != "AUTO" ]]; then
        vnctools_connect::resize_remote_vnc_session \
            $(bashargs::get_arg --username) \
            $(bashargs::get_arg --hostname) \
            ${remote_vnc_session} \
            $(bashargs::get_arg --resolution)
    fi


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
    vnctools_connect::clean_up
    wait
    sleep 0.1
    echo
}

function vnctools_connect::clean_up () {
    for job in `jobs -p`; do
        kill ${job}
    done
}

function vnctools_connect::execute_remote_command() {
    local username=$1
    local hostname=$2
    echo "$(${SSH} ${SSH_FLAGS} ${username}@${hostname} "\
        echo ${SSH_HEADER};${@:3}" 2>/dev/null | grep -A500 -m1 -e ${SSH_HEADER} | tail -n+2)"
}

function vnctools_connect::find_local_listening_port() {
    local port=$(vnctools_connect::_find_listening_port \
            "$(vnctools_connect::_query_local_listening_ports $1 $2)" "${@:3}")
    if [[ -z "${port}" ]]; then
        exit 1
    else
        echo ${port}
    fi
}

function vnctools_connect::find_remote_listening_port() {
    local port=$(vnctools_connect::_find_listening_port \
            "$(vnctools_connect::_query_remote_listening_ports $1 $2)" "${@:3}")
    if [[ -z "${port}" ]]; then
        exit 1
    else
        echo ${port}
    fi
}

function vnctools_connect::get_remote_vnc_session() {
    if [[ $# -gt 2 ]]; then
        local report="${@:3}"
    else
        local report="$(vnctools_connect::_query_remote_vnc_sessions $1 $2)"
    fi

    if [[ -z "${report}" ]]; then
        echo "ERROR: No available remote VNC session found." 1>&2
        exit 1
    elif [[ $(echo "${report}" | wc -l) -gt 1 ]]; then
        echo "WARNING: More than one VNC session found on remote host." 1>&2
    fi
    echo "${report}" | head -n 1 | sed 's/^://'
}

function vnctools_connect::new_remote_vnc_session() {
    local username=$1
    local hostname=$2
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            "vncserver -localhost ${@:3}"
}

function vnctools_connect::open_remote_vnc_session() {
    local username=$1
    local hostname=$2
    local remote_vnc_session=$3
    local localport=$4
    local remoteport=$5
    ${SSH} ${SSH_FLAGS} -f -t -L ${localport}:localhost:${remoteport} \
            ${username}@${hostname} \
            "x11vnc \
                -tag vnctools-x11vnc-${remote_vnc_session} \
                -display :${remote_vnc_session} \
                -rfbport ${remoteport} -localhost \
                -repeat -noshm -usepw -forever -noxdamage -snapfb -speeds dsl \
                ${@:6}"
}

function vnctools_connect::resize_remote_vnc_session() {
    local username=$1
    local hostname=$2
    local remote_vnc_session=$3
    local resolution=$4
    local refresh=60
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            "MONITOR=\$( (xrandr -display :${remote_vnc_session} | grep -e ' connected [^C]' | sed -e 's/\([A-Z0-9]\+\) connected.*/\1/') )
            MODELINE=\$(cvt $(echo ${resolution} | sed "s/x/ /") ${refresh} | grep -e \"Modeline [^(]\" | sed -e 's/.*Modeline //')
            MODEPARAMS=\$(echo \$MODELINE | sed -e 's/.*\" //')
            MODERES=\$(echo \$MODELINE | grep -o -P '(?<=\").*(?=\")')
            xrandr -display :${remote_vnc_session} --newmode \${MODERES} \${MODEPARAMS}
            xrandr -display :${remote_vnc_session} --addmode \${MONITOR} \${MODERES}
            xrandr -display :${remote_vnc_session} -s \${MODERES} --dpi 256
            "
}

function vnctools_connect::_find_listening_port() {
    if [[ $# -eq 1 ]]; then
        local port_min=${PORT_MIN}
        local port_max=${PORT_MAX}
        local report="$1"
    else
        local port_min="$2"
        local port_max="$3"
        local report="${@:4}"
    fi

    for (( port = ${port_min}; port <= $((port_max+1)); port++ )); do
        if ! [[ "${report}" =~ :${port} ]]; then
            break 1
        fi
    done

    if [[ ${port} -gt ${port_max} ]]; then
        echo "ERROR: No available port found between ${port_min} and ${port_max}" 1>&2
        exit 1
    fi
    echo ${port}
}

function vnctools_connect::_query_local_listening_ports() {
    echo "$(lsof -iTCP -sTCP:LISTEN -n -P 2> /dev/null | awk '{print $9}')"
}

function vnctools_connect::_query_remote_listening_ports() {
    local username=$1
    local hostname=$2
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            'netstat -tulpen4 | grep LISTEN | awk "{print \$4}"'
}

function vnctools_connect::_query_remote_vnc_sessions() {
    local username=$1
    local hostname=$2
    vnctools_connect::execute_remote_command ${username} ${hostname} \
            'vncserver -list | grep ^: | awk "{print \$1}"'
}
