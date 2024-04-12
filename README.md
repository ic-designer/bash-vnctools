# VNC tools
[![Makefile CI](https://github.com/ic-designer/bash-vnctools/actions/workflows/makefile.yml/badge.svg)](https://github.com/ic-designer/bash-vnctools/actions/workflows/makefile.yml)

## Installation

```bash
curl -sL https://github.com/ic-designer/bash-vnctools/archive/refs/tags/0.4.1.tar.gz | tar xz
make -C bash-vnctools-0.4.1 install
```

## Commands

### `vnctools-history`

Retrieves the last 1000 vnctools commands called by the current user.

```
usage: vnctools-history
```


### `vnctools-kill`

Connects to a remote server using ssh and kills the vnc desktop assigned to the display number.
This command also deletes the desktop lock files.

```
usage: vnctools-kill --username=<username> --hostname=<hostname> --display=<display>
                    [--trace]

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number
        --trace                     enable debug tracing
```


### `vnctools-list`

Connects to a remote server using ssh and lists the vnc desktops.

```
usage: vnctools-list --username=<username> --hostname=<hostname>
                    [--trace]

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --trace                     enable debug tracing

```


### `vnctools-open`

Opens the remote vnc desktop using an ssh tunnel.

```
usage: vnctools-open --username=<username> --hostname=<hostname> --display=<display>
                    [--localport=<localport>] [--remoteport=<remoteport>]
                    [--realvnc | --screenshare] [--sleep=<time>] [--x11args="<list of args>"]
                    [--trace]

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number
        --localport=<localport>     local forwarding port <localport> number (Default: 5900)
        --remoteport=<remoteport>   local forwarding port <remoteport> number (Default: AUTO)
        --realvnc                   open the desktop using realVNC app
        --screenshare               open the desktop using OSX screenshare app
        --sleep=<time>              <time> in seconds to wait between commands (Default: 4)
        --x11vnc="<list of args>"   <list of args> passed through to x11vnc (Default: "")
        --trace                     enable debug tracing

```


### `vnctools-start`

Connects to a remote server using ssh and starts a new desktop.

```
usage: vnctools-start --username=<username> --hostname=<hostname>
                      --display=<display> --geometry=<geometry>
                      [--trace]

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number
        --geometry=<geometry>       desktop <geometry> specified as <width>x<height>
        --trace                     enable debug tracing

```
