require "em-http-request"

module DiscogsData
  module Reader
    class GZipDecoder
      def call(enumerable)
        Enumerator.new do |yielder|
          decoder = EventMachine::HttpDecoders::GZip.new { |chunk| yielder << chunk }

          enumerable.each { |chunk| decoder << chunk }
          yielder << decoder.finalize.to_s
        end
      end
    end
  end
end
