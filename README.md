# Yard2steep

Generate [steep](https://github.com/soutaro/steep) type definition file from yard annotation.

:warning: **This is highly experimental project.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yard2steep'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yard2steep

## Usage

`yard2steep` generates steep type definition file from yard annotation.

```console
$ yard2steep lib sig
```

```ruby
# lib/parser.rb
class AST
  # @return [String]
  def to_s
    # Do something
    "AST"
  end
end

class Parser
  # @param [String] text
  # @return [AST]
  def parse(text)
    ast = AST.new
    # Do something
    ast
  end
end
```

`sig/parser.rbi` is generated.

```ruby
# sig/parser.rbi
class AST
  def to_s: -> String
end
class Parser
  def parse: (String) -> AST
end
```

After generating `.rbi` file, we can run `steep check` command to type check. (cf. [Usage of steep](https://github.com/soutaro/steep#usage) )

```
$ steep check lib -I sig
```

Congraturation! :tada:
You did type checking by yard annotation!


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/south37/yard2steep.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
