function test_vnctools_open_missing_display() {
    local return_code=0
    waxwing::monkey_patch_commands_to_record_command_name_only kill open ssh trap sleep
    $(vnctools-open --hostname=  --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_hostname() {
    local return_code=0
    waxwing::monkey_patch_commands_to_record_command_name_only kill open ssh trap sleep
    $(vnctools-open --display=  --username= ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_username() {
    local return_code=0
    waxwing::monkey_patch_commands_to_record_command_name_only kill open ssh trap sleep
    $(vnctools-open --display= --hostname=  ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_with_valid_args_and_default_options() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill
    waxwing::monkey_patch_commands_to_record_command_name_and_args open ssh trap sleep
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --username=username
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
ssh -CKf -o ConnectTimeout=2 username@hostname netstat -tulpen4
trap clean_up; exit 1 INT
trap echo "ERROR: \$(caller)" >&2 ERR
ssh -CKf -o ConnectTimeout=2 username@hostname pkill -9 -f -e vnctools-x11vnc-display
sleep 4
ssh -CKf -o ConnectTimeout=2 -L 5900:localhost:1024 username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport 1024 -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl
sleep 4
open -W vnc://localhost:5900
EOF
)
    [[ ${actual} == ${expected} ]]
}

function test_vnctools_open_with_valid_args_and_only_non_default_localport() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill sleep trap
    waxwing::monkey_patch_commands_to_record_command_name_and_args open ssh
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --username=username \
        --localport=localport
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
ssh -CKf -o ConnectTimeout=2 username@hostname netstat -tulpen4
trap
trap
ssh -CKf -o ConnectTimeout=2 username@hostname pkill -9 -f -e vnctools-x11vnc-display
sleep
ssh -CKf -o ConnectTimeout=2 -L localport:localhost:1024 username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport 1024 -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl
sleep
open -W vnc://localhost:localport
EOF
)
    [[ ${actual} == ${expected} ]]
}

function test_vnctools_open_with_valid_args_and_only_non_default_remoteport() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill open sleep trap
    waxwing::monkey_patch_commands_to_record_command_name_and_args ssh
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --username=username \
        --remoteport=remoteport
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
trap
trap
ssh -CKf -o ConnectTimeout=2 username@hostname pkill -9 -f -e vnctools-x11vnc-display
sleep
ssh -CKf -o ConnectTimeout=2 -L 5900:localhost:remoteport username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport remoteport -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl
sleep
open
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
ssh -CKf -o ConnectTimeout=2 username@hostname pkill -9 -f -e vnctools-x11vnc-display
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
