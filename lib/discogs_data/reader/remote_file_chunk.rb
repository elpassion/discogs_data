require "net/http"
require "uri"

require "discogs_data/reader/file_chunk"

module DiscogsData
  module Reader
    class RemoteFileChunk < FileChunk
      def call(url)
        uri = URI(url)

        Enumerator.new do |yielder|
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
            http.request_get(uri.request_uri) do |response|
              file_size     = response["content-length"].to_i
              file_progress = 0

              on_file_size&.call(file_size)

              response.read_body do |chunk|
                file_progress += chunk.bytesize

                on_file_progress&.call(chunk.bytesize, file_progress, file_size)

                yielder << chunk
              end
            end
          end
        end
      end
    end
  end
end
