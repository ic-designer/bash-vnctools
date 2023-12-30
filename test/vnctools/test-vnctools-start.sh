function test_vnctools_start_missing_display() {
    local return_code=0
    $(vnctools-start --geometry= --hostname= --username=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_start_missing_geometry() {
    local return_code=0
    $(vnctools-start --display= --hostname= --username=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_start_missing_hostname() {
    local return_code=0
    $(vnctools-start --display= --geometry= --username=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_start_missing_username() {
    local return_code=0
    $(vnctools-start --display= --geometry= --hostname=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_start_with_valid_args() {
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    vnctools-start \
        --display=display \
        --geometry=geometry \
        --hostname=hostname \
        --username=username
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
ssh username@hostname \
vncserver :display \
-geometry geometry \
-depth 16 \
-localhost \
vncserver -list
EOF
)
    [[ "${actual}" == "${expected}" ]]
}
