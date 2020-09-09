require "discogs_data/artists_xml"
require "discogs_data/reader/stream"

module DiscogsData
  class Artists
    def initialize(uri)
      @uri = uri
    end

    def parse(handler, limit = nil)
      parser = ArtistsXML.new(handler, limit: limit)

      Reader::Stream.parse(@uri, parser)
    end
  end
end
