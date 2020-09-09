require "ox"

require "discogs_data/model/artist"
require "discogs_data/model/artist_reference"
require "discogs_data/model/image"

module DiscogsData
  class ArtistsXML < ::Ox::Sax
    def initialize(handler, limit: nil)
      raise ArgumentError unless valid_limit?(limit)

      @handler = handler
      @limit   = limit
      @count   = 0
      @path    = []
    end

    def start_element(name)
      @path << name

      case @path
      when [:artists, :artist]                  then @artist = Model::Artist.new
      when [:artists, :artist, :namevariations] then @artist.name_variations = []
      when [:artists, :artist, :aliases]        then @artist.aliases = []
      when [:artists, :artist, :images]         then @artist.images = []
      when [:artists, :artist, :urls]           then @artist.urls = []
      when [:artists, :artist, :members]        then @artist.members = []
      when [:artists, :artist, :groups]         then @artist.groups = []
      when [:artists, :artist, :images, :image] then @artist.images << Model::Image.new
      when [:artists, :artist, :aliases, :name] then @artist.aliases << Model::ArtistReference.new
      when [:artists, :artist, :members, :name] then @artist.members << Model::ArtistReference.new
      when [:artists, :artist, :groups, :name]  then @artist.groups << Model::ArtistReference.new
      end
    end

    def end_element(name)
      case @path
      when [:artists, :artist]                         then handle_artist
      when [:artists, :artist, :id]                    then @artist.id = @text.to_i
      when [:artists, :artist, :name]                  then @artist.name = @text
      when [:artists, :artist, :realname]              then @artist.real_name = @text
      when [:artists, :artist, :profile]               then @artist.profile = @text
      when [:artists, :artist, :data_quality]          then @artist.data_quality = @text
      when [:artists, :artist, :namevariations, :name] then @artist.name_variations << @text
      when [:artists, :artist, :urls, :url]            then @artist.urls << @text
      when [:artists, :artist, :aliases, :name]        then @artist.aliases.last.name = @text
      when [:artists, :artist, :members, :name]        then @artist.members.last.name = @text
      when [:artists, :artist, :groups, :name]         then @artist.groups.last.name = @text
      end

      @path.pop
    end

    def attr(name, value)
      case @path
      when [:artists, :artist, :aliases, :name]
        @artist.aliases.last.id = value.to_i if name == :id
      when [:artists, :artist, :groups, :name]
        @artist.groups.last.id = value.to_i if name == :id
      when [:artists, :artist, :members, :name]
        @artist.members.last.id = value.to_i if name == :id
      when [:artists, :artist, :images, :image]
        image = @artist.images.last

        case name
        when :type   then image.type = value
        when :uri    then image.uri = value
        when :uri150 then image.uri150 = value
        when :width  then image.width = value.to_i
        when :height then image.height = value.to_i
        end
      end
    end

    def text(value)
      @text = value
    end

    private

    def handle_artist
      @count += 1

      raise ReadLimitReached if @limit && @count > @limit

      @handler.call(@artist)
    end

    def valid_limit?(limit)
      limit.nil? || (limit.is_a?(Integer) && limit > 0)
    end
  end
end
