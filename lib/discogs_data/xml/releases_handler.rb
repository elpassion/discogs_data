require_relative "../model/image"
require_relative "../model/release"
require_relative "../model/release_artist"
require_relative "../model/release_company"
require_relative "../model/release_format"
require_relative "../model/release_identifier"
require_relative "../model/release_label"
require_relative "../model/release_track"
require_relative "../model/video"

module DiscogsData
  module XML
    module ReleasesHandler
      def start_element(name)
        @path << name

        case @path.length
        when 2
          case name
          when :release then @release = Model::Release.new
          end
        when 3
          case name
          when :artists      then @artists = []
          when :companies    then @companies = []
          when :extraartists then @artists = []
          when :formats      then @formats = []
          when :genres       then @genres = []
          when :identifiers  then @identifiers = []
          when :images       then @images = []
          when :labels       then @labels = []
          when :styles       then @styles = []
          when :tracklist    then @tracklist = []
          when :videos       then @videos = []
          end
        when 4
          case name
          when :artist     then @artist = Model::ReleaseArtist.new
          when :company    then @company = Model::ReleaseCompany.new
          when :format     then @format = Model::ReleaseFormat.new
          when :identifier then @identifier = Model::ReleaseIdentifier.new
          when :image      then @image = Model::Image.new
          when :label      then @label = Model::ReleaseLabel.new
          when :track      then @track = Model::ReleaseTrack.new
          when :video      then @video = Model::Video.new
          end
        when 5
          case name
          when :descriptions then @format.descriptions = []
          when :artists      then @artists = []
          when :extraartists then @artists = []
          when :sub_tracks   then @sub_tracks = []
          end
        when 6
          case name
          when :artist then @artist = Model::ReleaseArtist.new
          when :track  then @sub_track = Model::ReleaseTrack.new
          end
        when 7
          case name
          when :artists      then @artists = []
          when :extraartists then @artists = []
          end
        when 8
          case name
          when :artist then @artist = Model::ReleaseArtist.new
          end
        end
      end

      def end_element(name)
        parent      = @path[-2]
        grandparent = @path[-3]
        depth       = @path.length

        if (depth == 4 || depth == 6 || depth == 8) && name == :artist
          @artists << @artist
        elsif (depth == 5 || depth == 7 || depth == 9) && parent == :artist
          case name
          when :id     then @artist.artist_reference = Model::ArtistReference.new(@text.to_i)
          when :name   then @artist.artist_reference.name = @text
          when :anv    then @artist.anv = @text
          when :join   then @artist.join = @text
          when :role   then @artist.role = @text
          when :tracks then @artist.tracks = @text
          end
        elsif (depth == 5 || depth == 7) && parent == :track
          track = grandparent == :tracklist ? @track : @sub_track

          case name
          when :position     then track.position = @text
          when :title        then track.title = @text
          when :duration     then track.duration = @text
          when :artists      then track.artists = @artists
          when :extraartists then track.extra_artists = @artists
          when :sub_tracks   then track.sub_tracks = @sub_tracks
          end
        else
          case depth
          when 2
            case name
            when :release then on_entity(@release)
            end
          when 3
            case name
            when :artists      then @release.artists = @artists
            when :companies    then @release.companies = @companies
            when :country      then @release.country = @text
            when :data_quality then @release.data_quality = @text
            when :extraartists then @release.extra_artists = @artists
            when :formats      then @release.formats = @formats
            when :genres       then @release.genres = @genres
            when :identifiers  then @release.identifiers = @identifiers
            when :images       then @release.images = @images
            when :labels       then @release.labels = @labels
            when :master_id    then @release.master_id = @text.to_i
            when :notes        then @release.notes = @text
            when :released     then @release.released = @text # TODO: Cast it to Date, create separate field for date segments (year, year_month, year_month_date)
            when :styles       then @release.styles = @styles
            when :title        then @release.title = @text
            when :tracklist    then @release.tracklist = @tracklist
            when :videos       then @release.videos = @videos
            end
          when 4
            case name
            when :company    then @companies << @company
            when :format     then @formats << @format
            when :genre      then @genres << @text
            when :identifier then @identifiers << @identifier
            when :image      then @images << @image
            when :label      then @labels << @label
            when :style      then @styles << @text
            when :track      then @tracklist << @track
            when :video      then @videos << @video
            end
          when 5
            case parent
            when :company
              case name
              when :id               then @company.label_reference = Model::LabelReference.new(@text.to_i)
              when :name             then @company.label_reference.name = @text
              when :entity_type      then @company.entity_type = @text
              when :entity_type_name then @company.entity_type_name = @text
              when :catno            then @company.catalog_number = @text
              when :resource_url     then @company.resource_url = @text
              end
            when :video
              case name
              when :title       then @video.title = @text
              when :description then @video.description = @text
              end
            end
          when 6
            case name
            when :description then @format.descriptions << @text
            when :track       then @sub_tracks << @sub_track
            end
          end
        end

        @path.pop
      end

      def attr(name, value)
        node  = @path[-1]
        depth = @path.length

        case depth
        when 2
          case node
          when :release
            case name
            when :id     then @release.id = value.to_i
            when :status then @release.status = value
            end
          end
        when 3
          case node
          when :master_id
            case name
            when :is_main_release then @release.master_main_release = (value == 'true')
            end
          end
        when 4
          case node
          when :video
            case name
            when :src      then @video.src = value
            when :duration then @video.duration = value.to_i
            when :embed    then @video.embed = (value == 'true')
            end
          when :label
            case name
            when :name  then @label.label_reference = Model::LabelReference.new(nil, value)
            when :catno then @label.catalog_number = value
            when :id    then @label.label_reference.id = value.to_i
            end
          when :format
            case name
            when :name then @format.name = value
            when :qty  then @format.qty = value.to_i
            when :text then @format.text = value
            end
          when :identifier
            case name
            when :type        then @identifier.type = value
            when :description then @identifier.description = value
            when :value       then @identifier.value = value
            end
          when :image
            case name
            when :type   then @image.type = value
            when :uri    then @image.uri = value
            when :uri150 then @image.uri150 = value
            when :width  then @image.width = value.to_i
            when :height then @image.height = value.to_i
            end
          end
        end
      end
    end
  end
end
