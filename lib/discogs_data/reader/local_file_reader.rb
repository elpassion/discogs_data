require "discogs_data/reader/file_reader"

module DiscogsData
  module Reader
    class LocalFileReader < FileReader
      def initialize(chunk_size: 1024, **args)
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
            @file = File.new(path)

            @file.each(nil, @chunk_size) do |chunk|
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
