require "discogs_data/artists_xml"
require "discogs_data/reader/stream"

module DiscogsData
  class Artists
    def initialize(uri)
      @uri = uri
    end

    def parse(handler, limit = nil, content_length_proc: nil, progress_proc: nil)
      parser = ArtistsXML.new(handler, limit: limit)

      Reader::Stream.parse(@uri, parser, content_length_proc: content_length_proc, progress_proc: progress_proc)
    end
  end
end
