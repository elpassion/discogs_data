module DiscogsData
  module Reader
    class FileChunk
      def initialize(chuck_size = 1024)
        @chuck_size = chuck_size
      end

      def call(path)
        Enumerator.new do |yielder|
          File.open(path).each(nil, 1024) { |chunk| yielder << chunk }
        end
      end
    end
  end
end
