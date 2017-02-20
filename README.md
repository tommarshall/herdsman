# Herdsman

Herdsman is a command line utility for working with multiple Git repositories.

## Installation

```sh
gem install herdsman
```

## Usage

```
Commands:
  herdsman help [COMMAND]  # Describe available commands or one specific command
  herdsman status          # Check the status of the repositories in the herd
  herdsman version         # Show the herdsman version

Options:
  q, [--quiet], [--no-quiet]
```

### `herdsman status`

`herdsman status` will check each of the repositories in the herd:
* for untracked files
* for modified files
* for unpushed commits
* for unpulled commits
* is on the specified revision (defaults to `master`)

```
$ herdsman status
WARN: foo-repo has untracked files
WARN: foo-repo has modified files
INFO: bar-repo is ok
WARN: baz-repo has unpushed commits
WARN: baz-repo has unpulled commits
WARN: baz-repo revision is not 'qux-branch'
```

Exits `0` if all checks pass. Exits `1` if any of the repositories in the herd fail any of the checks.

## Configuration

Configure the herd of repositories to manage with a `herdsman.yml` file in the current working directory.

Example:

```yml
repos:
  - /path/to/foo-repo
  - ../../path/to/bar-repo
  - path: /path/to/baz-repo
    revision: qux-branch    # defaults to `master` if unset
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Credits

* [Thoughtbot's gitsh](https://github.com/thoughtbot/gitsh) Git shell, which was referenced for much of the Git CLI integration.
