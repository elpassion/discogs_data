require "piperator"
require "uri"
require_relative "stream/gzip_extractor"
require_relative "stream/local_file_reader"
require_relative "stream/remote_file_reader"
require_relative "stream/xml_stream_parser"
require_relative "xml/dump_handler"

module DiscogsData
  class Dump
    def initialize(path_or_url)
      @path_or_url = path_or_url
    end

    def parse(on_entity, on_file_size: nil, on_file_progress: nil, limit: nil)
      uri          = URI(@path_or_url)
      local        = uri.scheme.nil?
      gzipped      = File.extname(uri.path) == ".gz"
      reader_class = local ? Stream::LocalFileReader : Stream::RemoteFileReader

      handler   = XML::DumpHandler.new(on_entity, limit: limit)
      reader    = reader_class.new(on_file_size: on_file_size, on_file_progress: on_file_progress)
      extractor = gzipped && Stream::GZipExtractor.new
      parser    = Stream::XMLStreamParser.new(handler)

      begin
        Piperator.build do
          wrap(uri.to_s)
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
