function test_vnctools_connect_find_local_listening_port() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args lsof awk
    vnctools_connect::find_local_listening_port user host
    local actual="$(waxwing::read_pipe | sort)"
    local expected="$(cat << EOF
awk {print \$9}
lsof -iTCP -sTCP:LISTEN -n -P
EOF
)"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_find_local_listening_port_min_port_available() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    local actual=$(vnctools_connect::find_local_listening_port user host 1024 1026 "$(cat << EOF
:1026
:1025
EOF
)")
    local expected="1024"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_find_local_listening_port_max_port_available() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    local actual=$(vnctools_connect::find_local_listening_port user host 1024 1026 "$(cat << EOF
:1024
:1025
EOF
)")
    local expected="1026"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_find_local_listening_port_mid_port_available() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    local actual=$(vnctools_connect::find_local_listening_port user host 1024 1026 "$(cat << EOF
:1024
:1026
EOF
)")
    local expected="1025"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_find_local_listening_port_no_port_available() {
    local return_code=0
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    $(vnctools_connect::find_local_listening_port user host 1024 1026 "$(cat << EOF
:1025
:1026
:1024
EOF
)") || return_code=1
    [[ $return_code -eq 1 ]]
}
