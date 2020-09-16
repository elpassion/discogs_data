require "ox"
require "discogs_data/labels_xml"

module DiscogsData
  class Labels
    def initialize(uri)
      @uri = uri
    end

    def parse(handler, limit = nil, content_length_proc: nil, progress_proc: nil)
      parser = LabelsXML.new(handler, limit: limit)

      Reader::Stream.parse(@uri, parser, content_length_proc: content_length_proc, progress_proc: progress_proc)
    end
  end
end
