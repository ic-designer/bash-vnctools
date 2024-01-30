function test_vnctools_open_missing_display() {
    local return_code=0
    $(vnctools-open \
        --hostname= \
        --localport= \
        --username=
    ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_hostname() {
    local return_code=0
    $(vnctools-open \
        --display= \
        --localport= \
        --username=
    ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_localport() {
    local return_code=0
    $(vnctools-open \
        --display= \
        --hostname= \
        --username=
    ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_missing_username() {
    local return_code=0
    $(vnctools-open \
        --display= \
        --hostname= \
        --localport= \
    ) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_vnctools_open_with_valid_args_and_default_options() {
    waxwing::monkey_patch_commands_to_record_command_name_only kill
    waxwing::monkey_patch_commands_to_record_command_name_and_args open ssh trap
    vnctools-open \
        --display=display \
        --hostname=hostname \
        --localport=localport \
        --username=username
    actual=$(waxwing::read_pipe)
    expected=$(cat << EOF
trap clean_up; exit 1 INT
ssh -4CKq -L localport:localhost:5900 username@hostname x11vnc -display :display -localhost -rfbport localport -usepw -once -noxdamage -snapfb -speeds dsl -shared -repeat -forever
open -W vnc://localhost:localport
kill
EOF
)
    [[ ${actual} == ${expected} ]]
}
