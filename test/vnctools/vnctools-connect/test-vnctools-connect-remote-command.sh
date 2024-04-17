function test_vnctools_connect_execute_remote_command_without_args() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh grep tail
    vnctools_connect::execute_remote_command user host
    local actual="$(waxwing::read_pipe | sort)"
    local expected="$(cat << EOF
grep -A500 -m1 -e ${SSH_HEADER}
${SSH} ${SSH_FLAGS} user@host echo ${SSH_HEADER};
tail -n+2
EOF
)"
     [[ ${actual} == ${expected} ]]
}

function test_vnctools_connect_execute_remote_command_with_args() {
    source $(which vnctools-connect)
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh grep tail
    vnctools_connect::execute_remote_command user host alpha beta
    local actual="$(waxwing::read_pipe | sort)"
    local expected="$(cat << EOF
grep -A500 -m1 -e ${SSH_HEADER}
${SSH} ${SSH_FLAGS} user@host echo ${SSH_HEADER};alpha beta
tail -n+2
EOF
)"
     [[ ${actual} == ${expected} ]]
}
