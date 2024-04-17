function test_vnctools_connect_constant_port_min() {
    source $(which vnctools-connect)
    [[ ${PORT_MIN} == 1024 ]]
}

function test_vnctools_connect_constant_port_max() {
    source $(which vnctools-connect)
    [[ ${PORT_MAX} == 65535 ]]
}

function test_vnctools_connect_constant_ssh() {
    source $(which vnctools-connect)
    [[ ${SSH} == 'ssh' ]]
}

function test_vnctools_connect_constant_ssh_flags() {
    source $(which vnctools-connect)
    [[ ${SSH_FLAGS} == '-CKf -o ConnectTimeout=2' ]]
}

function test_vnctools_connect_constant_ssh_flags() {
    source $(which vnctools-connect)
    [[ ${SSH_HEADER} == "--vnctools--" ]]
}
