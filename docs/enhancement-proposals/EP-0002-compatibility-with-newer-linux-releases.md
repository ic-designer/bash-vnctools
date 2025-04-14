# EP-0002 Compatibility with Newer Linux Releases.

    Name: Jeffrey Alan Fredenburg
    Date: 2024-06-19

## Summary

VNC tools suffers from compatibility issues with the newer linux releases. TigerVNC has
deprecated the `vncserver` script, and `x11vnc` no longer has a proper maintainer. These
scripts need a major update since they so reliant on on both `x11vnc` and the
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
                       [--type=<type>] [--display=<display>] [--localport=<localport>]
                       [--resolution=<resolution>] [--depth=<depth>]
                       [--realvnc | --screenshare] [--sleep=<time>] [--trace]

        --username=<username>       remote server <username>
        --hostname=<hostname>       remote server <hostname>
        --type=<type>               connection <type> (Default: AUTO)
        --display=<display>         desktop <display> number (Default: AUTO)
        --localport=<localport>     local forwarding port number (Default: AUTO)
        --resolution=<resolution>   desktop <resolution> specified as <width>x<height>
        --depth=<depth>             desktop pixel depth (Default: 24)
        --realvnc                   open the desktop using realVNC
        --screenshare               open the desktop using MacOS screenshare
        --sleep=<time>              wait <time> in seconds between commands (Default: 4)
        --trace                     enable debug tracing
```

Opens a remote VNC desktop through an SSH tunnel.

This command can create new VNC sessions and connect to existing VNC sessions on remote
servers. VNC session display numbers and forwarding ports can be auto-resolved,
and display properties such as resolution and depth can be adjusted on the fly. This
command provides a unified interface for establishing VNC connections from MacOS to
Linux machines.

The following connection type are supported:

- Use the standard systemd vncserver service with a user-assigned port number.
- Use direct calls to Xvnc with user-specified port numbers.
- Use direct calls to Xvnc with auto-resolved port numbers.


This command supports connection that use the standard systemd vncserver service. When
the connection type is set to systemd, `--type=systemd`, the command will try and
establish a VNC session using the systemd vncserver service with the user port mappings
from `/etc/tigervnc/vncserver.users`. An error is raised if a user port mapping is not
found. The command will connect to existing VNC session or create a new VNC session
using the user assigned port number. The display argument, `--display=<display>` is
ignored when establishing connections using the standard vncserver service.

This command supports direct calls to Xvnc using a copy of the legacy vncserver script.
When the connection type is set to Xvnc, `--type=xvnc`, the command will use the display
argument, `--display=<display>`, to determine the VNC display number to use. If a
display number is specified, the connect command will either create a new session or
connect to an existing session with that display number. An error is raised if a
connection cannot be established with the specified display. When the display number is
set to automatic, `--display=AUTO`, the connect command will either connect to an
existing Xvnc type session or will create a new session using the whatever free display
numbers are available. When the connection type is set to Xvnc, `--type=xvnc`, the
connect command will not attempt to connect to user assigned port number located in
`/etc/tigervnc/vncserver.users`. Futhermore, to help mitigate potential collisions,
the display numbers used by Xvnc connection types will be restricted to [50000, 60000].


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

### Launching `vncserver`


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
