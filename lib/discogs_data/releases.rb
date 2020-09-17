require "discogs_data/releases_xml"
require "discogs_data/reader/stream"

module DiscogsData
  class Releases
    def initialize(uri)
      @uri = uri
    end

    def parse(entity_callback, limit = nil, on_file_size: nil, on_file_progress: nil)
      xml_handler = ReleasesXML.new(entity_callback, limit: limit)

      Reader::Stream.parse(@uri, xml_handler, on_file_size: on_file_size, on_file_progress: on_file_progress)
    end
  end
end
