# VNC tools
[![Makefile CI](https://github.com/ic-designer/bash-vnctools/actions/workflows/makefile.yml/badge.svg)](https://github.com/ic-designer/bash-vnctools/actions/workflows/makefile.yml)

## Installation

```bash
curl -sL https://github.com/ic-designer/bash-vnctools/archive/refs/tags/0.3.0.tar.gz | tar xz
make -C bash-vnctools-0.3.0 install
```

## Commands

### `vnctools-kill`

Connects to a remote server using ssh and kills the vnc desktop assigned to the display number.
This command also deletes the desktop lock files.

```
usage: vnctools-kill --username=<username> --hostname=<hostname>
                     --display=<display>

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number
```


### `vnctools-list`

Connects to a remote server using ssh and lists the vnc desktops.

```
usage: vnctools-list --username=<username> --hostname=<hostname>

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
```


### `vnctools-open`

Opens the remote vnc desktop using an ssh tunnel.

```
usage: vnctools-open --username=<username> --hostname=<hostname>
                     --display=<display> --localport=<localport>
                    [ --realvnc | --screenshare ]

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number
        --localport=<localport>     <localport> number of the forwarded port
        --realvnc                   open the desktop using realVNC app
        --screenshare               open the desktop using OSX screenshare app

```


### `vnctools-start`

Connects to a remote server using ssh and starts a new desktop.

```
usage: vnctools-start --username=<username> --hostname=<hostname>
                      --display=<display> --geometry=<geometry>

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number
        --geometry=<geometry>       desktop <geometry> specified as <width>x<height>
```
