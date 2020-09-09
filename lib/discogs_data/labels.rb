require "ox"
require "discogs_data/labels_xml"

module DiscogsData
  class Labels
    def initialize(filename)
      @filename = filename
    end

    def each(&handler)
      File.open(@filename, "r") do |file|
        Ox.sax_parse(LabelsXML.new(handler), file)
      end
    end
  end
end
