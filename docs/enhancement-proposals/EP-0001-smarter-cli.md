# EP-0001 Smarter CLI

    Name: Jeffrey Alan Fredenburg
    Date: 2024-04-13

## Summary

A smarter command line interface (CLI) is needed for VNC Tools. The current CLI for
`vnctools-0.4.1` is very low level and requires the user to track many inconvenient
details about each VNC session. The user is responsible for tracking display numbers,
display resolutions, local port numbers, and remote port numbers. A smarter CLI could
manage these details for the user, thereby simplifying the interface and providing an
overall better experience for the user.

## Proposal

Introduce a new command to VNC Tools called `vnctools-connect` that combines the
functionality of both `vnctools-open` and `vnctools-start` into a single command. The
usage for this new `vnctools-connect` command is described below.

```
usage: vnctools-connect --username=<username> --hostname=<hostname>
                        [--display=<display>] [--resolution=<resolution>]
                        [--localport=<localport>] [--remoteport=<remoteport>]
                        [--realvnc | --screenshare] [--sleep=<time>]
                        [--x11args="<list of args>"] [--trace]

        --username=<username>       <username> provided to ssh
        --hostname=<hostname>       <hostname> provided to ssh
        --display=<display>         desktop <display> number (Default: AUTO)
        --resolution=<geometry>     desktop <resolution> specified as <width>x<height> (Default: 1920x1080)
        --localport=<localport>     local forwarding port <localport> number (Default: AUTO)
        --remoteport=<remoteport>   remote forwarding port <remoteport> number (Default: AUTO)
        --realvnc                   open the desktop using the RealVNC app
        --screenshare               open the desktop using the native screen sharing app
        --sleep=<time>              <time> in seconds to wait between executong commands (Default: 4)
        --x11vnc="<list of args>"   <list of args> passed directly to x11vnc (Default: "")
        --trace                     enable debug tracing
```

This command manages both the creation of new VNC sessions and the connection to remote
sessions. When executed, this command first queries the remote host for all the active
VNC sessions. If an active VNC session can be associated with the user, a connection
will be established with the remote session. If a VNC session cannot be associated with
the user, a new session will be created before connecting.

The `--display` option controls the display number associated with the VNC session.
When called with the default `AUTO` value, the `vnctools-connect` command will either
connect to the first VNC session found for the user or create a new VNC session using
the first available display before connecting. When a specific value is provided for
the `--display` option, the `vnctools-connect` command will either attempt to connect
to the specified display number or create a new VNC session with that specific display
number. An error is raised if the specified display number is unavailable. A warning is
raised if multiple active sessions are found on the remote host.

The `--resolution` option controls the VNC session resolution. If a VNC session cannot
be associated with the user, the `vnctools-connect` command will create a new session
with the specified resolution. If possible, the resolution for existing VNC sessions
will be resized before connecting.

The `--localport` option controls the local forwarding port number for the SSH tunnel.
When the default `AUTO` value is used, the `vnctools-connect` command will first query
the local system and identify the first available listening port. Otherwise, the
`vnctools-connect` command will attempt to establish the SSH tunnel using the specified
port number. An error is raised if the specified display local port number is
unavailable.

The `--remoteport` option controls the remote forwarding port number for the SSH
tunnel. When the `AUTO` value is used, the `vnctools-connect` command will first query
the remote system and identify the first available listening port. Otherwise, the
`vnctools-connect` command will attempt to establish the SSH tunnel using the specified
port number. An error is raised if the specified display remote port number is
unavailable.

## Future

A future enhancement could provide a bookkeeping mechanism to this command for tracking
each VNC sessions created by the user. This would enable a mechanism for reporting all
VNC sessions and possibly identify zombie processes.
