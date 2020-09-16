require "net/http"
require "uri"

module DiscogsData
  module Reader
    class HTTPFetch
      def initialize(content_length_proc: nil, progress_proc: nil)
        @content_length_proc = content_length_proc
        @progress_proc       = progress_proc
      end

      def call(url)
        uri = URI(url)

        Enumerator.new do |yielder|
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
            http.request_get(uri.request_uri) do |response|
              content_length = response['content-length'].to_i
              progress       = 0

              @content_length_proc&.call(content_length)

              response.read_body do |chunk|
                progress += chunk.bytesize

                @progress_proc&.call(progress, content_length)

                yielder << chunk
              end
            end
          end
        end
      end
    end
  end
end
