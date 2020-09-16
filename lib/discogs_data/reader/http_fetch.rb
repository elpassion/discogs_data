require "net/http"
require "uri"

module DiscogsData
  module Reader
    class HTTPFetch
      def initialize(file_size_proc: nil, file_progress_proc: nil)
        @file_size_proc     = file_size_proc
        @file_progress_proc = file_progress_proc
      end

      def call(url)
        uri = URI(url)

        Enumerator.new do |yielder|
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
            http.request_get(uri.request_uri) do |response|
              file_size     = response["content-length"].to_i
              file_progress = 0

              @file_size_proc&.call(file_size)

              response.read_body do |chunk|
                file_progress += chunk.bytesize

                @file_progress_proc&.call(chunk.bytesize, file_progress, file_size)

                yielder << chunk
              end
            end
          end
        end
      end
    end
  end
end
