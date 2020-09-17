module DiscogsData
  module Reader
    class FileChunk
      def initialize(on_file_size: nil, on_file_progress: nil)
        @on_file_size     = on_file_size
        @on_file_progress = on_file_progress
      end

      private

      attr_reader :on_file_size, :on_file_progress
    end
  end
end
