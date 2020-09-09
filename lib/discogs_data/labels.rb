require "ox"
require "discogs_data/labels_xml"

module DiscogsData
  class Labels
    def initialize(uri)
      @uri = uri
    end

    def parse(handler, limit = nil)
      parser = LabelsXML.new(handler, limit: limit)

      Reader::Stream.parse(@uri, parser)
    end
  end
end
