function test_vnctools_list_missing_hostname() {
    local return_code=0
    $(vnctools-list --username=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_list_missing_username() {
    local return_code=0
    $(vnctools-list --hostname=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_list_with_valid_args() {
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    vnctools-list \
        --hostname=hostname \
        --username=username
    actual=$(waxwing::read_pipe)
    expected="ssh username@hostname vncserver -list"
    [[ ${actual} == ${expected} ]]
}
