# Changelog

All notable changes to Rangu are documented in this file.

## 1.0.0 - 2026-07-19

### Added

- Added the `rangu` command-line interface with text, file, and standard-input modes.
- Added GitHub Actions coverage for Ruby 3.3, 3.4, and 4.0.
- Added grouped monthly Dependabot updates for Bundler and GitHub Actions.

### Changed

- Updated Rangu's spacing rules to match pangu.py 4.0.6.1 and added corresponding Minitest coverage.
- Made `Rangu.spacing` and `Rangu.spacing_text` immutable text-only APIs.
- Made `Rangu.spacing_file` the only file-reading API and preserved file contents.
- Replaced the RSpec suite with Minitest 6 and modernized the development toolchain to Bundler 4, Rake 13, and
  RuboCop 1.88.
- Raised the minimum supported Ruby version to 3.3.
- Enabled MFA-required RubyGems releases and restricted the gem push host to RubyGems.org.

### Breaking changes from 0.3.0

- CJK-adjacent ASCII punctuation is now normalized to full-width punctuation, and middle-dot variants are normalized
  to `・`.
- `Rangu.spacing(existing_path)` no longer reads the file at that path; call `Rangu.spacing_file(path)` instead.
- Input strings are no longer modified in place.
- Ruby versions older than 3.3 are no longer supported.
