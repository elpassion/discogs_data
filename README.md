# Discogs Data

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)
    
A set of tools for extracting, processing and importing Discogs monthly XML Data Dumps (https://data.discogs.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'discogs_data'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install discogs_data

## Usage

Initialize the `DiscogsData::Dump` class with a path to a remote or local file. The parser supports both gzipped and raw XML files:

```ruby
remote_gzipped_dump = DiscogsData::Dump.new("https://discogs-data.s3-us-west-2.amazonaws.com/data/2020/discogs_20200901_labels.xml.gz")
remote_raw_dump     = DiscogsData::Dump.new("https://myserver.example.com/discogs_20200901_labels.xml")
local_gzipped_dump  = DiscogsData::Dump.new("./discogs_20200901_labels.xml.gz")
local_raw_dump      = DiscogsData::Dump.new("./discogs_20200901_labels.xml")
```

You can process the dump file with a handler. The handler can be a lambda, a proc or a class with a `call` method:

```ruby
# Define the dump file:
labels_dump = DiscogsData::Dump.new("https://discogs-data.s3-us-west-2.amazonaws.com/data/2020/discogs_20200901_labels.xml.gz") 

# Inline lambda handler:
labels_dump.parse(->(label) { puts label.name })

# Proc handler passed as variable: 
handler = proc { |label| puts label.name }
labels_dump.parse(handler)

# Handler class:
class LabelHandler
  def call(label)
    puts label.name
  end
end

labels_dump.parse(LabelHandler.new)
```

You can limit the number of parsed entities by providing `limit` argument:

```ruby
DiscogsData::Dump.new("discogs_20200806_artists.xml.gz").parse(handler, limit: 10)
```

The parser automatically detects the type of entities inside the dump file:

```ruby
artists = []
handler = ->(artist) { artists << artist }

DiscogsData::Dump.new("discogs_20200806_artists.xml.gz").parse(handler)

artists.first.class # => DiscogsData::Model::Artist
```

The detection is based on the first XML element in the dump file (`<artists>`, `<labels>`, `<releases>`). If the parser does not recognise the entity type, it will raise `UnknownDumpFormat` exception. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/discogs_data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/discogs_data/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DiscogsData project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/discogs_data/blob/master/CODE_OF_CONDUCT.md).
