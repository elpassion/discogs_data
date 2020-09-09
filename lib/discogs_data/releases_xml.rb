require "ox"

require "discogs_data/model/release"
require "discogs_data/model/track"
require "discogs_data/model/track_artist"
require "discogs_data/model/image"

module DiscogsData
  class ReleasesXML < ::Ox::Sax
    def initialize(handler, limit: nil)
      raise ArgumentError unless valid_limit?(limit)

      @handler = handler
      @limit   = limit
      @count   = 0
      @path    = []
    end

    def start_element(name)
      @path << name

      depth  = @path.length
      parent = @path[-2]

      if depth == 2 && name == :release
        @release = Model::Release.new
      elsif depth == 3 && parent == :release
        case name
        when :tracklist then @release.tracklist = []
        end
      elsif depth == 4 && parent == :tracklist && name == :track
        @release.tracklist << Model::Track.new
      elsif depth == 5 && parent == :track && name == :artists
        @release.tracklist.last.artists = []
      elsif depth == 6 && @path[-3] == :track && parent == :artists && name == :artist
        @release.tracklist.last.artists << Model::TrackArtist.new
      end
    end

    def end_element(name)
      depth  = @path.length
      parent = @path[-2]

      if depth == 2 && name == :release
        handle_release
      elsif depth == 3 && parent == :release
        case name
        when :title     then @release.title = @text
        end
      elsif depth == 5 && parent == :track
        track = @release.tracklist.last

        case name
        when :position then track.position = @text
        when :title    then track.title = @text
        when :duration then track.duration = @text
        end
      elsif depth == 7 && @path[-4] == :track && @path[-3] == :artists && @path[-2] == :artist
        artist = @release.tracklist.last.artists.last

        case name
        when :id then artist.artist_reference = Model::ArtistReference.new(@text.to_i)
        when :name then artist.artist_reference.name = @text
        when :anv then artist.anv = @text
        when :join then artist.join = @text
        when :role then artist.role = @text
        when :tracks then artist.tracks = @text
        end
      end

      @path.pop
    end

    def attr(name, value)
      depth  = @path.length
      parent = @path[-2]
      node   = @path[-1]

      if parent == :releases && node == :release
        case name
        when :id     then @release.id = value.to_i
        when :status then @release.status = value
        end
      end
    end

    def text(value)
      @text = value
    end

    private

    def handle_release
      @count += 1

      raise ReadLimitReached if @limit && @count > @limit

      @handler.call(@release)
    end

    def valid_limit?(limit)
      limit.nil? || (limit.is_a?(Integer) && limit > 0)
    end
  end
end
