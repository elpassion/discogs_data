require "discogs_data/reader/file_chunk"

module DiscogsData
  module Reader
    class LocalFileChunk < FileChunk
      def initialize(chunk_size: 1024, **args)
        super(**args)

        @chunk_size = chunk_size
      end

      def call(path)
        Enumerator.new do |yielder|
          file_size     = File.size(path)
          file_progress = 0

          on_file_size&.call(file_size)

          File.open(path).each(nil, @chunk_size) do |chunk|
            file_progress += chunk.bytesize

            on_file_progress&.call(chunk.bytesize, file_progress, file_size)

            yielder << chunk
          end
        end
      end
    end
  end
end
