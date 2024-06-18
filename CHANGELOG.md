# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

```markdown
## [Unreleased] - YYYY-MM-DD
### Added
### Changed
### Deprecated
### Fixed
### Security
```

## [0.5.1] - 2024-06-18
### Added
### Changed
### Deprecated
### Fixed
- Fixed bug were vnctools-connect would prematurely exit and not connect if it had
  to create a new vnc session on the remote machine.
### Security


## [0.5.0] - 2024-06-06
### Added
- Created the `vnctools-connect` command that auto-resolves the display number and
  port settings.
- The `vnctools-open` command will now search for an open remote port when setting up
  the SSH tunnel.
- Added `workflow_dispatch` to allow manually triggering the action.
### Changed
- Default value for `vnctools-open` option `--remoteport` is changed from `5900` to
  `auto`.
- Updated the github workflow use checkout version 4 to update Node from 16 to 20.
### Fixed
- Added `-repeat` option to the `x11vnc` call to fix issue with keys repeating.


## [0.4.1] - 2024-02-19
### Added
- Added `--trace` argument to `vnctools-kill`, `vnctools-list`, `vnctools-open`, and
  `vnctools-start`.
- Added a 5900 default value to `--localport` argument of `vnctools-open` command.
- Added a 5900 default value to `--remoteport` argument of `vnctools-open` command.
### Fixed
- Fixed bug in `vnctools-open` command where `pgrep` wasn't finding the correct process to kill
  before starting a new x11vnc process.


## [0.4.0] - 2024-02-12
### Added
- Added the optional argument `--x11vnc="<args>"` to `vnctools-open` so x11vnc issues can debugged
  without modifying the `vnctools-open` script.
- Added an error trap to the `vnctools-open` script to increase verbosity during errors.
- Added the required argument `--remoteport` to `vnctools-open` to control which port that x11vnc
  uses to forward the display.
- Created the command `vnctools-history` to record invocations of the `vnctools` commands.
### Fixed
- Timeout option `-o ConnectTimeout=2` added to stop ssh from hanging on bad username or hostname.
- Removed `-q` option from `ssh` so command will show error messages.
- The `-noshm` option is added to `x11vnc` command in `vnctools-open` command to fix error with
  `shmget` unable to access memory.
- Fixed issue where `make clean` didn't remove the `.waxwing` directory.
- Existing x11vnc processes now identified by a unique tag
- Remove ssh options forcing only ivp4 addressing.


## [0.3.4] - 2024-01-30
### Fixed
- Fixed bug where x11vnc blocks ports after repeated usage. This may be the real issue that was
  attempted to be fixed by patch 0.3.3.
- The `vnctools-open` command will now attempt to remove background x11vnc process in `cleanup()`


## [0.3.3] - 2024-01-18
### Fixed
- Fixed bug where port mismatches can occur between the forwared tunnel port and x11vnc port.


## [0.3.2] - 2024-01-16
### Added
- Created tests for the Makefile.
### Changed
- Makefile configuration settings moved to `private.mk`.
- Updated bashargs to 0.3.1.


## [0.3.1] - 2024-01-10
### Added
- Version for dependencies can be controlled with the following variables: `BASHARGS_VERSION`,
  `BOXERBIRD_BRANCH`, and `WAXWING_BRANCH`.
- The Makefile variable `WORKDIR_ROOT`` can now be overidden on the command line.
### Changed
- Build dependencies are now populated under `$(WORKDIR_ROOT)/deps/`.
- Build artifacts are now populated under `$(WORKDIR_ROOT)/build/`.
- Test artifacts are now populated under`$(WORKDIR_ROOT)/test/`.


## [0.3.0] - 2024-01-09
### Changed
- Removed the version string from the vnctool scripts.
- Removed the version string from the install directories to simplify uninstall


## [0.2.0] - 2024-01-08
### Changed
- Repo migrated from personal organization to `ic-designer` organization.
- Renamed the Makefile from `makefile` to `Makefile`.
- Removed the `pkg_list` and `pkg_override` targets.
- Restructured Makefile internal variables to reduce the number of variables.
- Shared makefile utilities are now cloned from the Boxerbird repo
- Removed the `bash` subdirectory from the `src` path layout.
### Fixed
- Corrected issue with GitHub workflow where make target were not properly ran by calling each
  make target as a seperate command.


## [0.1.0] - 2023-12-30
### Added
- Executable bash scripts to manage vnc connections from macos to linux using x11vnc and port forwarding.
- Test scripts
- Makefile to build and run tests
- GitHub workflow to perform automated testing
