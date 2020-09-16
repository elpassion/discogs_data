require "ox"
require "discogs_data/labels_xml"

module DiscogsData
  class Labels
    def initialize(uri)
      @uri = uri
    end

    def parse(entity_callback, limit = nil, file_size_proc: nil, file_progress_proc: nil)
      xml_handler = LabelsXML.new(entity_callback, limit: limit)

      Reader::Stream.parse(@uri, xml_handler, file_size_proc: file_size_proc, file_progress_proc: file_progress_proc)
    end
  end
end
