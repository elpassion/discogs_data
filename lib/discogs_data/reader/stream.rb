require "piperator"
require "uri"

require "discogs_data/reader/file_chunk"
require "discogs_data/reader/gzip_decoder"
require "discogs_data/reader/http_fetch"
require "discogs_data/reader/io_parser"

module DiscogsData
  module Reader
    class Stream
      def self.parse(url, parser, content_length_proc: nil, progress_proc: nil)
        uri = URI(url)
        local = uri.scheme.nil?
        gzipped = File.extname(uri.path) == ".gz"
        fetcher_class = local ? FileChunk : HTTPFetch
        fetcher = fetcher_class.new(content_length_proc: content_length_proc, progress_proc: progress_proc)

        Piperator.build do
          pipe(fetcher)
          pipe(GZipDecoder.new) if gzipped
          pipe(IOParser.new(parser))
        end.call(url)
      end
    end
  end
end
