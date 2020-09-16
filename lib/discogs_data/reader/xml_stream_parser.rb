require "piperator"
require "ox"

module DiscogsData
  module Reader
    class XMLStreamParser
      def initialize(xml_handler)
        @xml_handler = xml_handler
      end

      def call(enumerable)
        io = Piperator::IO.new(enumerable.each)

        begin
          Ox.sax_parse(@xml_handler, io)
        rescue ReadLimitReached
        end
      end
    end
  end
end
