# Rangu

[![Build Status](https://travis-ci.org/bugtender/rangu.svg?branch=master)](https://travis-ci.org/bugtender/rangu)

Paranoid text spacing for good readability, to automatically insert whitespace between CJK (Chinese, Japanese, Korean) and half-width characters (alphabetical letters, numerical digits and symbols).

This is the Ruby copy version from [Vinta](https://github.com/vinta)'s [pangu.py](https://github.com/vinta/pangu.py).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rangu'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rangu

## Usage

```ruby
require "rangu"

Rangu.spacing("當你凝視著bug，bug也凝視著你")
=> "當你凝視著 bug，bug 也凝視著你"

Rangu.spacing("path/to/file.txt")
=> "與 PM 戰鬥的人，應當小心自己不要成為 PM"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bugtender/rangu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rangu project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bugtender/rangu/blob/master/CODE_OF_CONDUCT.md).
