# require "discogs_data/reader/file_chunk"
# require "discogs_data/reader/http_fetch"
# require "discogs_data/reader/g_zip_decoder"
# require "discogs_data/reader/io_parser"

require 'piperator'
require 'uri'
require 'em-http-request'
require 'net/http'

require_relative "http_fetch"
require_relative "g_zip_decoder"
require_relative "file_chunk"
require_relative "io_parser"
require_relative "../artists_xml"

module DiscogsData
  module Reader
    class Stream
      def self.parse(url, parser)
        uri = URI(url)
        local = uri.scheme.nil?
        gzipped = File.extname(uri.path) == '.gz'

        Piperator.build do
          pipe(local ? FileChunk.new : HTTPFetch.new)
          pipe(GZipDecoder.new) if gzipped
          pipe(IOParser.new(parser))
        end.call(url)
      end
    end
  end
end
