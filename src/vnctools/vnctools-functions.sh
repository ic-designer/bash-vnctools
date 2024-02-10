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

function vnctools::_history_file() {
    if [[ -n ${VNCTOOLS_HISTORY_FILE++} ]]; then
        echo "${VNCTOOLS_HISTORY_FILE}"
    else
        echo "${HOME}/.local/shared/.vnctools-history"
    fi
}
