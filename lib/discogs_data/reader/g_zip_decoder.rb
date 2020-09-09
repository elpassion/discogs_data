module DiscogsData
  module Reader
    class GZipDecoder
      def call(enumerable)
        Enumerator.new do |yielder|
          decoder = EventMachine::HttpDecoders::GZip.new do |chunk|
            yielder << chunk
          end

          enumerable.each { |chunk| decoder << chunk }
          yielder << decoder.finalize.to_s
        end
      end
    end
  end
end
