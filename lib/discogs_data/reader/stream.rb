require "piperator"
require "uri"

require "discogs_data/reader/local_file_reader"
require "discogs_data/reader/gzip_decoder"
require "discogs_data/reader/remote_file_reader"
require "discogs_data/reader/xml_stream_parser"

module DiscogsData
  module Reader
    class Stream
      def self.parse(url, xml_handler, on_file_size: nil, on_file_progress: nil)
        uri          = URI(url)
        local        = uri.scheme.nil?
        gzipped      = File.extname(uri.path) == ".gz"
        reader_class = local ? LocalFileReader : RemoteFileReader

        reader    = reader_class.new(on_file_size: on_file_size, on_file_progress: on_file_progress)
        extractor = gzipped && GZipDecoder.new
        parser    = XMLStreamParser.new(xml_handler)

        begin
          Piperator.build do
            wrap(url)
            pipe(reader)
            pipe(extractor) if extractor
            pipe(parser)
          end.call
        ensure
          reader&.close_io
        end
      end
    end
  end
end
