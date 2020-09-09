require "ox"
require "discogs_data/releases_xml"

module DiscogsData
  class Releases
    def initialize(uri)
      @uri = uri
    end

    def parse(handler, limit = nil)
      parser = ReleasesXML.new(handler, limit: limit)

      Reader::Stream.parse(@uri, parser)
    end
  end
end
