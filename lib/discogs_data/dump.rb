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

    def each(callback = nil, limit: nil, &block)
      raise ArgumentError, "cannot define both callback and block" if callback && block

      uri          = URI(@path_or_url)
      local        = uri.scheme.nil?
      gzipped      = File.extname(uri.path) == ".gz"
      reader_class = local ? Stream::LocalFileReader : Stream::RemoteFileReader

      handler   = XML::DumpHandler.new(callback || block, limit: limit, on_dump_type: callbacks[:dump_type])
      reader    = reader_class.new(on_file_size: callbacks[:file_size], on_file_progress: callbacks[:file_progress])
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
    alias_method :parse, :each

    def on(event, &block)
      callbacks[event] = block

      self
    end

    private

    def callbacks
      @callbacks ||= {}
    end
  end
end
