require "ox"

require "discogs_data/model/artist"
require "discogs_data/model/artist_reference"
require "discogs_data/model/image"

module DiscogsData
  class ReleasesXML < ::Ox::Sax
    def initialize(handler, limit: nil)
      raise ArgumentError unless valid_limit?(limit)

      @handler = handler
      @limit   = limit
      @count   = 0
      @path    = []
    end

    def start_element(name)
      @path << name
    end

    def end_element(name)

      @path.pop
    end

    def attr(name, value)
    end

    def text(value)
      @text = value
    end

    private

    def handle_release
      @count += 1

      raise ReadLimitReached if @limit && @count > @limit

      @handler.call(@release)
    end

    def valid_limit?(limit)
      limit.nil? || (limit.is_a?(Integer) && limit > 0)
    end
  end
end
