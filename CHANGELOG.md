# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [v0.3.0] - 2017-04-17

### Added

* `--fetch-cache=SECONDS`/`-c` option.
* `--revision`/`-r` option.
* `defaults:` config with support for `revision:` and `fetch_cache:`.
* Glob support for `path:`.

### Fixed

* Missing `thor` dependency in gemspec.

## [v0.2.0] - 2017-03-01

### Added

* `repositories:` alias for `repos:` config.
* Optional `fetch_cache:` property to `repos:` config.
* Optional `name:` property to `repos:` config.

## v0.1.0 - 2017-02-20

### Added

* `herdsman.yml` config file with `repos:` config, with `path:` and optional `revision:` properties for each repo.
* `status` command.
* `version` command.
* `--quiet`/`-q` option.

[Unreleased]: https://github.com/tommarshall/herdsman/compare/v0.3.0...HEAD
[v0.3.0]: https://github.com/tommarshall/herdsman/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/tommarshall/herdsman/compare/v0.1.0...v0.2.0
