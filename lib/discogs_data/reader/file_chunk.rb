module DiscogsData
  module Reader
    class FileChunk
      def initialize(file_size_proc: nil, file_progress_proc: nil, chunk_size: 1024)
        @file_size_proc     = file_size_proc
        @file_progress_proc = file_progress_proc
        @chunk_size         = chunk_size
      end

      def call(path)
        Enumerator.new do |yielder|
          file_size     = File.size(path)
          file_progress = 0

          @file_size_proc&.call(file_size)

          File.open(path).each(nil, @chunk_size) do |chunk|
            file_progress += chunk.bytesize

            @file_progress_proc&.call(chunk.bytesize, file_progress, file_size)

            yielder << chunk
          end
        end
      end
    end
  end
end
