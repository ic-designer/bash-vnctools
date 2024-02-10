function test_vnctools_history_kill() {
    export VNCTOOLS_HISTORY_FILE=.vnctools-history-${FUNCNAME}
    if [[ -f ${VNCTOOLS_HISTORY_FILE} ]]; then
        rm ${VNCTOOLS_HISTORY_FILE}
    fi
    $(vnctools-kill alpha beta gamma) || true

    actual=$(cat ${VNCTOOLS_HISTORY_FILE})
    expected="vnctools-kill alpha beta gamma"
    [[ "${actual}" == "${expected}" ]]
}

function test_vnctools_history_list() {
    export VNCTOOLS_HISTORY_FILE=.vnctools-history-${FUNCNAME}
    if [[ -f ${VNCTOOLS_HISTORY_FILE} ]]; then
        rm ${VNCTOOLS_HISTORY_FILE}
    fi
    $(vnctools-list alpha beta gamma) || true

    actual=$(cat ${VNCTOOLS_HISTORY_FILE})
    expected="vnctools-list alpha beta gamma"
    [[ "${actual}" == "${expected}" ]]
}

function test_vnctools_history_open() {
    export VNCTOOLS_HISTORY_FILE=.vnctools-history-${FUNCNAME}
    if [[ -f ${VNCTOOLS_HISTORY_FILE} ]]; then
        rm ${VNCTOOLS_HISTORY_FILE}
    fi
    $(vnctools-open alpha beta gamma) || true

    actual=$(cat ${VNCTOOLS_HISTORY_FILE})
    expected="vnctools-open alpha beta gamma"
    [[ "${actual}" == "${expected}" ]]
}

function test_vnctools_history_start() {
    export VNCTOOLS_HISTORY_FILE=.vnctools-history-${FUNCNAME}
    if [[ -f ${VNCTOOLS_HISTORY_FILE} ]]; then
        rm ${VNCTOOLS_HISTORY_FILE}
    fi
    $(vnctools-start alpha beta gamma) || true

    actual=$(cat ${VNCTOOLS_HISTORY_FILE})
    expected="vnctools-start alpha beta gamma"
    [[ "${actual}" == "${expected}" ]]
}

function test_vnctools_history() {
    export VNCTOOLS_HISTORY_FILE=.vnctools-history-${FUNCNAME}
    if [[ -f ${VNCTOOLS_HISTORY_FILE} ]]; then
        rm ${VNCTOOLS_HISTORY_FILE}
    fi
    $(vnctools-kill alpha beta gamma) || true
    $(vnctools-list alpha beta gamma) || true
    $(vnctools-open alpha beta gamma) || true
    $(vnctools-start alpha beta gamma) || true

    actual=$(cat ${VNCTOOLS_HISTORY_FILE})
    expected=$(cat << EOF
vnctools-kill alpha beta gamma
vnctools-list alpha beta gamma
vnctools-open alpha beta gamma
vnctools-start alpha beta gamma
EOF
)
    [[ "${actual}" == "${expected}" ]]
}

function test_vnctools_history_custom_home_path() {
    export HOME=home
    unset VNCTOOLS_HISTORY_FILE
    local VNCTOOLS_HISTORY_FILE=${HOME}/.local/shared/.vnctools-history
    if [[ -f ${VNCTOOLS_HISTORY_FILE} ]]; then
        rm ${VNCTOOLS_HISTORY_FILE}
    fi
    $(vnctools-kill alpha beta gamma) || true
    actual=$(cat ${VNCTOOLS_HISTORY_FILE})
    expected="vnctools-kill alpha beta gamma"
    [[ "${actual}" == "${expected}" ]]
}
