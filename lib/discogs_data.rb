require "discogs_data/version"
require "discogs_data/artists"
require "discogs_data/labels"
require "discogs_data/releases"

module DiscogsData
  class Error < StandardError; end
  class ReadLimitReached < Error; end
end
