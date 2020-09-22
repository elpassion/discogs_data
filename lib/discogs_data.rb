require_relative "discogs_data/version"
require_relative "discogs_data/dump"

module DiscogsData
  class Error < StandardError; end
  class ReadLimitReached < Error; end
  class UnknownDumpFormat < Error; end
end
