require "piperator"
require "ox"

module DiscogsData
  module Reader
    class IOParser
      def initialize(handler)
        @handler = handler
      end

      def call(enumerable)
        io = Piperator::IO.new(enumerable.each)

        begin
          Ox.sax_parse(@handler, io)
        rescue ReadLimitReached
        end
      end
    end
  end
end
