# TODO

1. Explicitly invoke Bash in the remote ssh command to prevent issue with `set -x` usage.
2. Consider a manifest install list that goes with the install instead of depending on Make to
   figure which files to uninstall.
3. Consider how to lock down dependency versions
4. Add a vnctools history file to keep track of the past N or so commands
