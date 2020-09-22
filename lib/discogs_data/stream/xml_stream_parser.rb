require "ox"
require "piperator"

module DiscogsData
  module Stream
    class XMLStreamParser
      def initialize(xml_handler)
        @xml_handler = xml_handler
      end

      def call(enumerable)
        io = Piperator::IO.new(enumerable.each)

        begin
          Ox.default_options = {encoding: "UTF-8", invalid_replace: "?"}
          Ox.sax_parse(@xml_handler, io, convert_special: true)
        rescue ReadLimitReached
        end
      end
    end
  end
end
