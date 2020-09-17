require "piperator"
require "uri"

require "discogs_data/reader/local_file_chunk"
require "discogs_data/reader/gzip_decoder"
require "discogs_data/reader/remote_file_chunk"
require "discogs_data/reader/xml_stream_parser"

module DiscogsData
  module Reader
    class Stream
      def self.parse(url, xml_handler, on_file_size: nil, on_file_progress: nil)
        uri           = URI(url)
        local         = uri.scheme.nil?
        gzipped       = File.extname(uri.path) == ".gz"
        fetcher_class = local ? LocalFileChunk : RemoteFileChunk
        fetcher       = fetcher_class.new(on_file_size: on_file_size, on_file_progress: on_file_progress)

        Piperator.build do
          pipe(fetcher)
          pipe(GZipDecoder.new) if gzipped
          pipe(XMLStreamParser.new(xml_handler))
        end.call(url)
      end
    end
  end
end
