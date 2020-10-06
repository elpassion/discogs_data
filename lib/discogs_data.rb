require_relative "discogs_data/version"
require_relative "discogs_data/dump"

module DiscogsData
  class Error < StandardError; end
  class ReadLimitReached < Error; end
  class UnknownDumpFormat < Error; end

  def self.user_agent
    @user_agent ||= "#{gemspec.name.split("_").map(&:capitalize).join}/#{gemspec.version} +#{gemspec.homepage}"
  end

  private_class_method def self.gemspec
    @gemspec ||= Gem::Specification.load("discogs_data.gemspec")
  end
end
