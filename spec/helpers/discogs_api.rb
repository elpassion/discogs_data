require "open-uri"

module Helpers
  class DiscogsAPI
    API_URL = "https://api.discogs.com/"

    def self.fetch_label(label_id)
      api("labels/#{label_id}")
    end

    private_class_method def self.api(path)
      json_string = URI.open("#{API_URL}#{path}", "User-Agent" => DiscogsData.user_agent).read

      JSON.parse(json_string, symbolize_names: true)
    end
  end
end