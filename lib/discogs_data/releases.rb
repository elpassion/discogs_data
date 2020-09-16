require "ox"
require "discogs_data/releases_xml"

module DiscogsData
  class Releases
    def initialize(uri)
      @uri = uri
    end

    def parse(handler, limit = nil, content_length_proc: nil, progress_proc: nil)
      parser = ReleasesXML.new(handler, limit: limit)

      Reader::Stream.parse(@uri, parser, content_length_proc: content_length_proc, progress_proc: progress_proc)
    end
  end
end
