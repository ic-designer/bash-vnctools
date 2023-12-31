function test_vnctools_kill_missing_display() {
    local return_code=0
    $(vnctools-kill --hostname= --username=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_kill_missing_hostname() {
    local return_code=0
    $(vnctools-kill --display= --username=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_kill_missing_username() {
    local return_code=0
    $(vnctools-kill --display= --hostname=) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_kill_with_valid_args() {
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    vnctools-kill \
        --display=display \
        --hostname=hostname \
        --username=username
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
ssh username@hostname \
set -x \
vncserver -kill :display \
rm -f /tmp/.Xdisplay-lock \
rm -f /tmp/.X11-unix/Xdisplay \
vncserver -list
EOF
)
    [[ "${actual}" == "${expected}" ]]
}
