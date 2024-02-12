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
    waxwing::monkey_patch_commands_to_record_command_name_and_args open ssh trap
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
ssh -CKf -o ConnectTimeout=2 -L localport:localhost:remoteport username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport remoteport -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl
open -W vnc://localhost:localport
EOF
)
    [[ ${actual} == ${expected} ]]
}

function test_vnctools_open_with_valid_args_and_x11vnc_options() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill
    waxwing::monkey_patch_commands_to_record_command_name_and_args open ssh trap
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --localport=localport \
        --remoteport=remoteport \
        --username=username \
        --x11vnc="alpha beta --gamma"
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
trap clean_up; exit 1 INT
trap echo "ERROR: \$(caller)" >&2 ERR
ssh -CKf -o ConnectTimeout=2 username@hostname kill -9 \$(pgrep -f vnctools-x11vnc-display)
ssh -CKf -o ConnectTimeout=2 -L localport:localhost:remoteport username@hostname x11vnc \
-tag vnctools-x11vnc-display -display :display -rfbport remoteport -localhost -noshm -usepw \
-forever -noxdamage -snapfb -speeds dsl alpha beta --gamma
open -W vnc://localhost:localport
EOF
)
    [[ ${actual} == ${expected} ]]
}
