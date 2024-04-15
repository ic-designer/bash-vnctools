function test_vnctools_connect_get_remote_listening_port() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args \
            vnctools_connect::execute_remote_command
    vnctools_connect::get_remote_listening_port user host
    local actual="$(waxwing::read_pipe)"
    local expected="$(cat << EOF
vnctools_connect::execute_remote_command user host netstat -tulpen4 | grep LISTEN | awk "{print \$4}"
EOF
)"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_get_remote_listening_port_min_port_available() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    local actual=$(vnctools_connect::get_remote_listening_port user host 1024 1026 "$(cat << EOF
:1026
:1025
EOF
)")
    local expected="1024"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_get_remote_listening_port_max_port_available() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    local actual=$(vnctools_connect::get_remote_listening_port user host 1024 1026 "$(cat << EOF
:1024
:1025
EOF
)")
    local expected="1026"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_get_remote_listening_port_mid_port_available() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    local actual=$(vnctools_connect::get_remote_listening_port user host 1024 1026 "$(cat << EOF
:1024
:1026
EOF
)")
    local expected="1025"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_get_remote_listening_port_no_port_available() {
    local return_code=0
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    $(vnctools_connect::get_remote_listening_port user host 1024 1026 "$(cat << EOF
:1025
:1026
:1024
EOF
)") || return_code=1
    [[ $return_code -eq 1 ]]
}
