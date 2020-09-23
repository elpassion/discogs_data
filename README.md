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

### Specify the file

Initialize the `DiscogsData::Dump` class with a path to a remote or local file. The parser supports both gzipped and raw XML files:

```ruby
remote_gzip = DiscogsData::Dump.new("https://discogs-data.s3-us-west-2.amazonaws.com/data/2020/discogs_20200901_labels.xml.gz")
remote_raw  = DiscogsData::Dump.new("https://myserver.example.com/discogs_20200901_labels.xml")
local_gzip  = DiscogsData::Dump.new("discogs_20200901_labels.xml.gz")
local_raw   = DiscogsData::Dump.new("discogs_20200901_labels.xml")
```

### Process the data

You can process the dump file with a block:

```ruby
labels_dump = DiscogsData::Dump.new("https://discogs-data.s3-us-west-2.amazonaws.com/data/2020/discogs_20200901_labels.xml.gz") 
labels_dump.each { |label| puts label.name }
```

You can also process the dump file with a handler. The handler can be a lambda, a proc or an object with a `call` method:

```ruby
class ArrayHandler
  attr_reader :entities

  def initialize
    @entities = []
  end

  def call(entity)
    @entities << entity
  end
end

@handler = ArrayHandler.new

DiscogsData::Dump.new("discogs_20200806_artists.xml.gz").each(@handler)

puts @handler.entities.count
```

You can limit the number of parsed entities by providing `limit` argument:

```ruby
DiscogsData::Dump.new("discogs_20200806_artists.xml.gz").each(limit: 10) { |artist| puts artist.name }
```

The parser automatically detects the type of entities inside the dump file:

```ruby
DiscogsData::Dump.new("discogs_20200806_artists.xml.gz").each(limit: 1) { |artist| puts artist.class } # => DiscogsData::Model::Artist
```

The detection is based on the first XML element in the dump file (`<artists>`, `<labels>`, `<releases>`). If the parser does not recognise the entity type, it will raise `UnknownDumpFormat` exception. 

### Register callbacks

You can register callbacks to receive notification when certain events occur. This allows you to eg. check the progress of the parsing process:

```ruby
require "ruby-progressbar"

@progress_bar = ProgressBar.create
@count        = 0

DiscogsData::Dump.new("https://discogs-data.s3-us-west-2.amazonaws.com/data/2020/discogs_20200901_labels.xml.gz").
  on(:file_size)     { |file_size|  @progress_bar.total = file_size }.
  on(:file_progress) { |chunk_size| @progress_bar.progress += chunk_size }.
  on(:dump_type)     { |dump_type|  @progress_bar.title = dump_type.to_s.capitalize }.
  each               { |label|      @count += 1 }

@progress_bar.log("Parsed #{@count} labels")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elpassion/discogs_data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/discogs_data/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DiscogsData project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/discogs_data/blob/master/CODE_OF_CONDUCT.md).
