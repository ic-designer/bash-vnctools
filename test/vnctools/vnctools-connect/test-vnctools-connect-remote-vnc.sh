function test_vnctools_connect_get_remote_vnc_session() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args \
            vnctools_connect::execute_remote_command
    $(vnctools_connect::get_remote_vnc_session user host)
    local actual=$(waxwing::read_pipe)
    local expected=$(cat << EOF
vnctools_connect::execute_remote_command user host vncserver -list | grep ^: | awk "{print \$1}"
EOF
)
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_get_remote_vnc_session_none_available() {
    local return_code=0
    source $(which vnctools-connect)
    $(vnctools_connect::get_remote_vnc_session user host "$(cat << EOF
EOF
)") || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_connect_get_remote_vnc_session_one_available() {
    source $(which vnctools-connect)
    local actual=$(vnctools_connect::get_remote_vnc_session user host "$(cat << EOF
:1
EOF
)")
    local expected="1"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_get_remote_vnc_session_two_available() {
    source $(which vnctools-connect)
    local actual=$(vnctools_connect::get_remote_vnc_session user host "$(cat << EOF
:2
:1
EOF
)")
    local expected="2"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_new_remote_vnc_session() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args \
            vnctools_connect::execute_remote_command
    $(vnctools_connect::new_remote_vnc_session user host alpha beta)
    local actual=$(waxwing::read_pipe)
    local expected=$(cat << EOF
vnctools_connect::execute_remote_command user host vncserver -localhost alpha beta
EOF
)
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_open_remote_vnc_session() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    $(vnctools_connect::open_remote_vnc_session \
            user host remote_vnc_session localport remoteport  alpha beta)
    local actual="$(waxwing::read_pipe)"
    local expected=$(cat << EOF
${SSH} ${SSH_FLAGS} -f -t -L localport:localhost:remoteport \
user@host \
x11vnc \
-tag vnctools-x11vnc-remote_vnc_session \
-display :remote_vnc_session \
-rfbport remoteport -localhost \
-repeat -noshm -usepw -forever -noxdamage -snapfb -speeds dsl \
alpha beta
EOF
)
     [[ ${actual} == ${expected} ]]
}
