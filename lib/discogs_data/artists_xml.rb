require "ox"

require "discogs_data/model/artist"
require "discogs_data/model/artist_reference"
require "discogs_data/model/image"

module DiscogsData
  class ArtistsXML < ::Ox::Sax
    def initialize(entity_callback, limit: nil)
      raise ArgumentError unless valid_limit?(limit)

      @entity_callback = entity_callback
      @limit           = limit
      @count           = 0
      @path            = []
    end

    def start_element(name)
      @path << name

      depth  = @path.length
      parent = @path[-2]

      if depth == 2 && name == :artist
        @artist = Model::Artist.new
      elsif depth == 3 && parent == :artist
        case name
        when :namevariations then @artist.name_variations = []
        when :aliases        then @artist.aliases = []
        when :images         then @artist.images = []
        when :urls           then @artist.urls = []
        when :members        then @artist.members = []
        when :groups         then @artist.groups = []
        end
      elsif depth == 4
        if parent == :images && name == :image
          @artist.images << Model::Image.new
        elsif parent == :aliases && name == :name
          @artist.aliases << Model::ArtistReference.new
        elsif parent == :members && name == :name
          @artist.members << Model::ArtistReference.new
        elsif parent == :groups && name == :name
          @artist.groups << Model::ArtistReference.new
        end
      end
    end

    def end_element(name)
      depth  = @path.length
      parent = @path[-2]

      if depth == 2 && name == :artist
        handle_artist
      elsif depth == 3
        case name
        when :id           then @artist.id = @text.to_i
        when :name         then @artist.name = @text
        when :realname     then @artist.real_name = @text
        when :profile      then @artist.profile = @text
        when :data_quality then @artist.data_quality = @text
        end
      elsif depth == 4
        if parent == :namevariations && name == :name
          @artist.name_variations << @text
        elsif parent == :urls && name == :url
          @artist.urls << @text
        elsif parent == :aliases && name == :name
          @artist.aliases.last.name = @text
        elsif parent == :members && name == :name
          @artist.members.last.name = @text
        elsif parent == :groups && name == :name
          @artist.groups.last.name = @text
        end
      end

      @path.pop
    end

    def attr(name, value)
      depth  = @path.length
      parent = @path[-2]
      node   = @path[-1]

      return unless depth == 4

      if parent == :aliases && node == :name && name == :id
        @artist.aliases.last.id = value.to_i
      elsif parent == :groups && node == :name && name == :id
        @artist.groups.last.id = value.to_i
      elsif parent == :members && node == :name && name == :id
        @artist.members.last.id = value.to_i
      elsif parent == :images && node == :image
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

      @entity_callback.call(@artist)
    end

    def valid_limit?(limit)
      limit.nil? || (limit.is_a?(Integer) && limit > 0)
    end
  end
end
