# Rangu

[![CI](https://github.com/bugtender/rangu/actions/workflows/ci.yml/badge.svg)](https://github.com/bugtender/rangu/actions/workflows/ci.yml)
[![Gem Version](https://img.shields.io/gem/v/rangu.svg)](https://rubygems.org/gems/rangu)

Rangu inserts readable spacing between CJK characters and half-width letters, numbers, and symbols. It provides an
immutable Ruby API and a command-line interface.

This is the Ruby copy version from [Vinta](https://github.com/vinta)'s [pangu.py](https://github.com/vinta/pangu.py).

Rangu requires Ruby 3.3 or newer and has no runtime dependencies.

## Installation

Add Rangu to your bundle:

```shell
bundle add rangu
```

Or install the gem directly:

```shell
gem install rangu
```

## Ruby API

```ruby
require "rangu"

Rangu.spacing("當你凝視著bug，bug也凝視著你")
# => "當你凝視著 bug，bug 也凝視著你"

Rangu.spacing_text("Ruby中文")
# => "Ruby 中文"

Rangu.spacing_file("notes.txt")
# => the spaced UTF-8 contents of notes.txt
```

`Rangu.spacing` is the primary text API, and `Rangu.spacing_text` is an alias. Both always treat their argument as
text, leave the original string unchanged, accept frozen strings, and return a distinct string. `Rangu.spacing_file`
is the only file-reading API; it reads UTF-8 and never writes the file. File and encoding errors are passed through to
the caller.

When CJK text is present, Rangu also normalizes adjacent ASCII punctuation such as `~!;:,.?` to full-width forms and
normalizes `·`, `•`, and `‧` to `・`. Leading and trailing whitespace is removed from CJK results.

## Command-line interface

```shell
rangu "當你凝視著bug，bug也凝視著你"
rangu --text "Ruby中文"
rangu --file notes.txt
printf "中文Ruby" | rangu
rangu --version
rangu --help
```

Text, file, and positional modes are mutually exclusive. Explicit input takes priority over standard input, and stdin
is read only when no explicit input is provided. Results go to stdout; usage, option, and file errors go to stderr with
a non-zero exit status. The CLI never edits a file in place.

## Upgrading from 0.3.0

Rangu 1.0.0 has four intentional breaking changes:

- ASCII punctuation adjacent to CJK text is now normalized to full-width punctuation, including middle-dot conversion.
- `Rangu.spacing(existing_path)` no longer detects or reads files. Use `Rangu.spacing_file(path)` explicitly.
- Spacing APIs no longer modify the input string and always return a separate string.
- The minimum supported Ruby version is now 3.3.

## Development

Install Ruby 3.3 or newer and Bundler 4, then run:

```shell
bin/setup
bundle exec rake
```

The default Rake task runs the Minitest suite and RuboCop. Individual checks and the package build are also available:

```shell
bundle exec rake test
bundle exec rubocop
bundle exec rake build
```

Bug reports and pull requests are welcome in the [issue tracker](https://github.com/bugtender/rangu/issues). By
participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Manual release

1. Update `Rangu::VERSION` and `CHANGELOG.md` in a release commit.
2. Run `bundle exec rake` and `bundle exec rake build`.
3. Inspect `pkg/rangu-VERSION.gem`, then install it into a temporary `GEM_HOME` for a smoke test.
4. Create and push an annotated `vVERSION` tag.
5. Publish with `gem push --host https://rubygems.org --otp OTP pkg/rangu-VERSION.gem`.

RubyGems publishing is restricted to `https://rubygems.org`, and all owners must have multi-factor authentication
enabled. Releases are manual; CI does not publish gems.

## License

Rangu is available under the [MIT License](LICENSE).
