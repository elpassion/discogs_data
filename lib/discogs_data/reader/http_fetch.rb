module DiscogsData
  module Reader
    class HTTPFetch
      def call(url)
        uri = URI(url)

        Enumerator.new do |yielder|
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            request = Net::HTTP::Get.new(uri.request_uri)

            http.request request do |response|
              response.read_body { |chunk| yielder << chunk }
            end
          end
        end
      end
    end
  end
end
