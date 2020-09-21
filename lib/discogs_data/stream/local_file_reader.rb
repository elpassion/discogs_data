require "discogs_data/stream/file_reader"

module DiscogsData
  module Stream
    class LocalFileReader < FileReader
      DEFAULT_FILE_BUFFER = 4096 # 4 KB

      def initialize(chunk_size: DEFAULT_FILE_BUFFER, **args)
        super(**args)

        @chunk_size = chunk_size
      end

      def call(path)
        @file = nil

        Enumerator.new do |yielder|
          file_size     = File.size(path)
          file_progress = 0

          on_file_size&.call(file_size)

          begin
            @file = File.open(path, "r")

            while chunk = @file.read(@chunk_size)
              file_progress += chunk.bytesize

              on_file_progress&.call(chunk.bytesize, file_progress, file_size)

              yielder << chunk
            end
          ensure
            close_io
          end
        end
      end

      def close_io
        @file&.close
      end
    end
  end
end
