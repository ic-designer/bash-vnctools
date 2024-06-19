# EP-0002 Compatibility with Newer Linux Releases.

    Name: Jeffrey Alan Fredenburg
    Date: 2024-06-19

## Summary

VNC tools suffers from compatibility issues with newer linux releases. TigerVNC has
deprecated the `vncserver` script, and `x11vnc` does not have a proper maintainer. The
scripts need a major update since they relied so heavily on both `x11vnc` and the
`vncserver` command.


## Proposal



VNC tools will consist of the following commands
- `vnctools-connect`
- `vnctools-history`
- `vnctools-kill`
- `vnctools-list`


### `vnctools-connnect`

```
usage: vnctools-connect --username=<username> --hostname=<hostname>
                       [--display=<display>] [--localport=<localport>]
                       [--remoteport=<remoteport>] [--resolution=<resolution>]
                       [--depth=<depth>] [--realvnc | --screenshare] [--sleep=<time>]
                       [--trace]

        --username=<username>       remote server <username>
        --hostname=<hostname>       remote server <hostname>
        --display=<display>         desktop <display> number (Default: AUTO)
        --localport=<localport>     local forwarding port number (Default: AUTO)
        --remoteport=<remoteport>   remote forwarding port number (Default: AUTO)
        --resolution=<resolution>   desktop <resolution> specified as <width>x<height>
        --depth=<depth>             desktop pixel depth (Default: 24)
        --realvnc                   open the desktop using realVNC app
        --screenshare               open the desktop using OSX screenshare app
        --sleep=<time>              wait <time> in seconds between commands (Default: 4)
        --trace                     enable debug tracing
```

Opens a remote VNC desktop using an ssh tunnel. If not explicitly specified, this
command will autodetect available ports and display numbers for establishing a VNC
session. When detecting the display number, the command will poll the remote server
for any existing VNC sessions. If a session is discovered, the command will connect to
the discoverd session number, otherwise, the command will first create a new VNC session
and then connect to that session number.


### `vnctools-history`

```
usage: vnctools-history
```

Retrieves the last 1000 vnctools commands called by the current user.


### `vnctools-kill`

```
usage: vnctools-kill --username=<username> --hostname=<hostname>
                    {--display=<display> | --all} [--trace]

        --username=<username>       remote server <username>
        --hostname=<hostname>       remote server <hostname>
        --display=<display>         <display> number to kill
        --all                       kills all active user displays
        --trace                     enable debug tracing
```

Connects to a remote server and terminate VNC sessions. If a specific display number
is provided, all sessions matching the process tag `<username>@<hostname>:<display>`
are terminated. If the `--all` switch is provided, all displays associate with the user
are terminated. This command will also perform housekeeping to ensure the lock files
located in `/tmp/.X*-lock` and `/tmp/.X11-unix/X*` are removed.


### `vnctools-list`

```
usage: vnctools-list --username=<username> --hostname=<hostname>
                    [--trace]

        --username=<username>       remote server <username>
        --hostname=<hostname>       remote server <hostname>
        --trace                     enable debug tracing

```
Connects to a remote server using ssh and lists active VNC sessions. This command uses
identifies active VNC sessions by lock files located under `/tmp/.X*-lock`.


## Requirements

### Process Tag

The VNC tool commands identify active processes using the `-desktop` argument as a tag.
When the VNC session is started, the following command will be used.
```
startx /etc/X11/xinit/Xsession gnome-session -- \
    /usr/bin/Xvnc :<display> \
        -desktop <id-desktop>
        -geometry <geometry>
        -depth <depth>
        -localhost
        -fp catalogue:/etc/X11/fontpath.d
        -auth ${HOME}/.Xauthority
        -rfbauth ${HOME}/.vnc/passwd
        -pn
        -rfbport <rfbport>'
```

VNC processes will be uniquely identified by the command `xinit` and the argument
`-desktop <desktop>`. The desktop string shall adhere to the following format:
`<username>@<hostname>:<display>` so as to remain unique.

### Display and Port Numbers

TigerVNC has deprecated the `vncserver` script, and the new way requires mapping a
specific display number to each user. To avoid conflicts with those display numbers,
we will start from port numbers 1024 and display numbers 1024. As long as these ports
work, there shouldn't be any conflict.
