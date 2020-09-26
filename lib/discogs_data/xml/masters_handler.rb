require_relative "../model/image"
require_relative "../model/master"
require_relative "../model/release_artist"
require_relative "../model/video"

module DiscogsData
  module XML
    module MastersHandler
      def start_element(name)
        @path << name

        case @path.size
        when 2
          case name
          when :master then @master = Model::Master.new
          end
        when 3
          case name
          when :artists,
               :genres,
               :images,
               :styles,
               :videos then @master[name] = []
          end
        when 4
          case name
          when :artist then @master[:artists] << Model::ReleaseArtist.new
          when :image  then @master[:images] << Model::Image.new
          when :video  then @master[:videos] << Model::Video.new
          end
        end
      end

      def end_element(name)
        case @path.size
        when 2
          case name
          when :master then on_entity(@master)
          end
        when 3
          case name
          when :data_quality,
               :notes,
               :title        then @master[name] = @text
          when :main_release then @master[:main_release_id] = @text.to_i
          when :year         then @master[:year] = @text.to_i
          end
        when 4
          case name
          when :genre then @master[:genres] << @text
          when :style then @master[:styles] << @text
          end
        when 5
          case name
          when :id          then @master[:artists].last[:artist_reference] = Model::ArtistReference.new(@text.to_i)
          when :name        then @master[:artists].last[:artist_reference][:name] = @text
          when :anv,
               :join,
               :role,
               :tracks      then @master[:artists].last[name] = @text
          when :description,
               :title       then @master[:videos].last[name] = @text
          end
        end

        @path.pop
      end

      def attr(name, value)
        node = @path.last

        case @path.size
        when 2
          case node
          when :master
            case name
            when :id then @master[:id] = value.to_i
            end
          end
        when 4
          case node
          when :video
            case name
            when :src      then @master[:videos].last[:src] = value
            when :duration then @master[:videos].last[:duration] = value.to_i
            when :embed    then @master[:videos].last[:embed] = (value == 'true')
            end
          when :image
            case name
            when :type,
                 :uri,
                 :uri150 then @master[:images].last[name] = value
            when :width,
                 :height then @master[:images].last[name] = value.to_i
            end
          end
        end
      end
    end
  end
end
