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

## [Unreleased] - YYYY-MM-DD
### Added
### Changed
- Removed the version string from the vnctool scripts.
- Removed the version string from the install directories to simplify uninstall
### Deprecated
### Fixed
### Security


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
