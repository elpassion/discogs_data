require "piperator"
require "uri"

require "discogs_data/reader/file_chunk"
require "discogs_data/reader/gzip_decoder"
require "discogs_data/reader/http_fetch"
require "discogs_data/reader/xml_stream_parser"

module DiscogsData
  module Reader
    class Stream
      def self.parse(url, xml_handler, file_size_proc: nil, file_progress_proc: nil)
        uri           = URI(url)
        local         = uri.scheme.nil?
        gzipped       = File.extname(uri.path) == ".gz"
        fetcher_class = local ? FileChunk : HTTPFetch
        fetcher       = fetcher_class.new(file_size_proc: file_size_proc, file_progress_proc: file_progress_proc)

        Piperator.build do
          pipe(fetcher)
          pipe(GZipDecoder.new) if gzipped
          pipe(XMLStreamParser.new(xml_handler))
        end.call(url)
      end
    end
  end
end
