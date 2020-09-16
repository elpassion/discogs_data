module DiscogsData
  module Reader
    class FileChunk
      def initialize(content_length_proc: nil, progress_proc: nil, chunk_size: 1024)
        @content_length_proc = content_length_proc
        @progress_proc       = progress_proc
        @chunk_size          = chunk_size
      end

      def call(path)
        Enumerator.new do |yielder|
          content_length = File.size(path)
          progress       = 0

          @content_length_proc&.call(content_length)

          File.open(path).each(nil, @chunk_size) do |chunk|
            progress += chunk.bytesize

            @progress_proc&.call(progress, content_length)

            yielder << chunk
          end
        end
      end
    end
  end
end
