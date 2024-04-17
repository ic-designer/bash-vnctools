function test_vnctools_connect_missing_hostname() {
    local return_code=0
    waxwing::monkey_patch_commands_to_record_command_name_only kill open ssh trap sleep
    $(vnctools-connect --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_connect_missing_username() {
    local return_code=0
    waxwing::monkey_patch_commands_to_record_command_name_only kill open ssh trap sleep
    $(vnctools-connect --display= --hostname=  ) || return_code=1
    [[ $return_code -eq 1 ]]
}
