require "discogs_data/labels_xml"
require "discogs_data/reader/stream"

module DiscogsData
  class Labels
    def initialize(uri)
      @uri = uri
    end

    def parse(entity_callback, limit = nil, on_file_size: nil, on_file_progress: nil)
      xml_handler = LabelsXML.new(entity_callback, limit: limit)

      Reader::Stream.parse(@uri, xml_handler, on_file_size: on_file_size, on_file_progress: on_file_progress)
    end
  end
end
