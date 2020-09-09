require "ox"

require "discogs_data/model/label"
require "discogs_data/model/label_reference"
require "discogs_data/model/image"

module DiscogsData
  class LabelsXML < ::Ox::Sax
    def initialize(handler, limit: nil)
      @handler = handler
      @limit   = limit
      @count   = 0
      @path    = []
    end

    def start_element(name)
      @path << name

      case @path
      when [:labels, :label]                     then @label = Model::Label.new
      when [:labels, :label, :parentLabel]       then @label.parent_label = Model::LabelReference.new
      when [:labels, :label, :urls]              then @label.urls = []
      when [:labels, :label, :images]            then @label.images = []
      when [:labels, :label, :sublabels]         then @label.sublabels = []
      when [:labels, :label, :images, :image]    then @label.images << Model::Image.new
      when [:labels, :label, :sublabels, :label] then @label.sublabels << Model::LabelReference.new
      end
    end

    def end_element(name)
      case @path
      when [:labels, :label]                     then handle_label
      when [:labels, :label, :id]                then @label.id = @text.to_i
      when [:labels, :label, :name]              then @label.name = @text
      when [:labels, :label, :profile]           then @label.profile = @text
      when [:labels, :label, :contactinfo]       then @label.contact_info = @text
      when [:labels, :label, :data_quality]      then @label.data_quality = @text
      when [:labels, :label, :urls, :url]        then @label.urls << @text
      when [:labels, :label, :parentLabel]       then @label.parent_label.name = @text
      when [:labels, :label, :sublabels, :label] then @label.sublabels.last.name = @text
      end

      @path.pop
    end

    def attr(name, value)
      case @path
      when [:labels, :label, :parentLabel]
        @label.parent_label.id = value.to_i
      when [:labels, :label, :sublabels, :label]
        @label.sublabels.last.id = value.to_i
      when [:labels, :label, :images, :image]
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

    def text(value)
      @text = value
    end

    private

    def handle_label
      @count += 1

      raise ReadLimitReached if @limit && @count > @limit

      @handler.call(@label)
    end
  end
end
