function test_vnctools_open_missing_display() {
    local return_code=0
    $(vnctools-open --hostname= --localport= --remoteport= --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_hostname() {
    local return_code=0
    $(vnctools-open --display= --localport= --remoteport= --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_localport() {
    local return_code=0
    $(vnctools-open --display= --hostname= --remoteport= --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_remoteport() {
    local return_code=0
    $(vnctools-open --display= --hostname= --localport= --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_username() {
    local return_code=0
    $(vnctools-open --display= --hostname= --localport= --remoteport= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_with_valid_args_and_default_options() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill
    waxwing::monkey_patch_commands_to_record_command_name_and_args open ssh trap sleep
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --localport=localport \
        --remoteport=remoteport \
        --username=username
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
trap clean_up; exit 1 INT
trap echo "ERROR: \$(caller)" >&2 ERR
ssh -CKf -o ConnectTimeout=2 username@hostname kill -9 \$(pgrep -f vnctools-x11vnc-display)
sleep 4
ssh -CKf -o ConnectTimeout=2 -L localport:localhost:remoteport username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport remoteport -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl
sleep 4
open -W vnc://localhost:localport
EOF
)
    [[ ${actual} == ${expected} ]]
}

function test_vnctools_open_with_valid_args_and_sleep_option() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill open ssh trap
    waxwing::monkey_patch_commands_to_record_command_name_and_args sleep
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --localport=localport \
        --remoteport=remoteport \
        --username=username \
        --sleep=1
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
trap
trap
ssh
sleep 1
ssh
sleep 1
open
EOF
)
    [[ ${actual} == ${expected} ]]
}

function test_vnctools_open_with_valid_args_and_x11vnc_options() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill open sleep trap
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --localport=localport \
        --remoteport=remoteport \
        --username=username \
        --x11vnc="alpha beta --gamma"
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
trap
trap
ssh -CKf -o ConnectTimeout=2 username@hostname kill -9 \$(pgrep -f vnctools-x11vnc-display)
sleep
ssh -CKf -o ConnectTimeout=2 -L localport:localhost:remoteport username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport remoteport -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl alpha beta --gamma
sleep
open
EOF
)
    [[ ${actual} == ${expected} ]]
}
