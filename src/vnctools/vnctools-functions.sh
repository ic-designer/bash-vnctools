VNCTOOLS_SSH_CMD='ssh'
VNCTOOLS_SSH_FLAGS='-CKT -o ConnectTimeout=2'
VNCTOOLS_SSH_HEADER='--vnctools--'

function vnctools::_append_history() {
    local history_file=$(vnctools::_history_file)
    if [[ ! -f ${history_file} ]]; then
        if [[ ! ${history_file%/*} = ${history_file} ]]; then
            mkdir -p ${history_file%/*}
        fi
    fi
    echo "${BASH_SOURCE##*/} $*" >> ${history_file}
    echo "$(tail -n 1000 ${history_file})" > ${history_file}
}

function vnctools_connect::_execute_remote_command() {
    local username=$1
    local hostname=$2
    echo "$(${VNCTOOLS_SSH_CMD} ${VNCTOOLS_SSH_FLAGS} ${username}@${hostname} "\
        echo ${VNCTOOLS_SSH_HEADER};${@:3}" 2>/dev/null | \
                grep -A500 -m1 -e ${VNCTOOLS_SSH_HEADER} | tail -n+2)"
}

function vnctools::_history_file() {
    if [[ -n ${VNCTOOLS_HISTORY_FILE++} ]]; then
        echo "${VNCTOOLS_HISTORY_FILE}"
    else
        echo "${HOME}/.local/shared/.vnctools-history"
    fi
}
