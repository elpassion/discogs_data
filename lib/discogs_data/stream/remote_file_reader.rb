require "net/http"
require "uri"
require_relative "file_reader"

module DiscogsData
  module Stream
    class RemoteFileReader < FileReader
      def call(url)
        uri = URI(url)

        Enumerator.new do |yielder|
          begin
            @http = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https")

            @http.request_get(uri.request_uri) do |response|
              file_size     = response["content-length"].to_i
              file_progress = 0

              on_file_size&.call(file_size)

              response.read_body do |chunk|
                file_progress += chunk.bytesize

                on_file_progress&.call(chunk.bytesize, file_progress, file_size)

                yielder << chunk
              end
            end
          ensure
            close_io
          end
        end
      end

      def close_io
        @http.finish if @http&.active?
      end
    end
  end
end
