# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [7.0.0]
### Added
- Add support for Puppet 8 and stm-debconf 6 (#113)
- Add support for Ubuntu 24.04 and Debian 12 (#116)
### Removed
- BREAKING CHANGE: drop support for Puppet 6 (#113)
- BREAKING CHANGE: drop support for Ubuntu 18.04 (#116)

## [6.3.0]
### Removed
- drop Debian 9 support
### Changed
- Allow debconf < 6.0.0
### Added
- Add AIX support (#107)
- EL9 yaml file (#108)

## [6.2.0]
### Removed
- Dropped stdlib dependency (#103)
### Changed
- Test improvements
### Added
- Added CHANGELOG
- Support Puppet 7
