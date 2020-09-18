require "em-http-request"

module DiscogsData
  module Stream
    class GZipExtractor
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
