require "ox"

require "discogs_data/model/label"
require "discogs_data/model/label_reference"
require "discogs_data/model/image"

module DiscogsData
  module XML
    module LabelsHandler
      def start_element(name)
        @path << name

        depth  = @path.length
        parent = @path[-2]

        if depth == 2 && name == :label
          @label = Model::Label.new
        elsif depth == 3 && parent == :label
          case name
          when :parentLabel then @label.parent_label = Model::LabelReference.new
          when :urls        then @label.urls = []
          when :images      then @label.images = []
          when :sublabels   then @label.sublabels = []
          end
        elsif depth == 4 && parent == :images && name == :image
          @label.images << Model::Image.new
        elsif depth == 4 && parent == :sublabels && name == :label
          @label.sublabels << Model::LabelReference.new
        end
      end

      def end_element(name)
        depth  = @path.length
        parent = @path[-2]

        if depth == 2 && name == :label
          on_entity(@label)
        elsif depth == 3 && parent == :label
          case name
          when :id           then @label.id = @text.to_i
          when :name         then @label.name = @text
          when :profile      then @label.profile = @text
          when :contactinfo  then @label.contact_info = @text
          when :data_quality then @label.data_quality = @text
          when :parentLabel  then @label.parent_label.name = @text
          end
        elsif depth == 4 && parent == :urls && name == :url
          @label.urls << @text
        elsif depth == 4 && parent == :sublabels && name == :label
          @label.sublabels.last.name = @text
        end

        @path.pop
      end

      def attr(name, value)
        case @path.last
        when :parentLabel
          @label.parent_label.id = value.to_i
        when :label
          @label.sublabels.last.id = value.to_i if @path.size == 4
        when :image
          image = @label.images.last

          case name
          when :type   then image.type = value
          when :uri    then image.uri = value
          when :uri150 then image.uri150 = value
          when :width  then image.width = value.to_i
          when :height then image.height = value.to_i
          end
        end
      end
    end
  end
end