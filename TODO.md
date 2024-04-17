# TODO

- Consider how to lock down dependency versions
- Consider how to added dependency versions as target dependencies
- Turn on the x11vnc logging option
- Fixed a bug with waxwing where `errexit`` and `waxwing::pipe`` were not handled
  properly, so revisit how commands are called -- i.e., commands called within command
  substitution to avoid `errexit`.
- Need to test the vnctools_connect::resize_remote_vnc_session
- Need to really test the vnctools_connect logic
