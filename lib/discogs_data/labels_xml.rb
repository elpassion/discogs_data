require "discogs_data/label"
require "discogs_data/label_reference"
require "discogs_data/image"

module DiscogsData
  class LabelsXML < ::Ox::Sax
    def initialize(handler)
      @handler = handler
      @path = []
    end

    def start_element(name)
      @path << name

      case @path
      when [:labels, :label]
        @label = Label.new
      when [:labels, :label, :urls]
        @urls = []
      when [:labels, :label, :images]
        @images = []
      when [:labels, :label, :sublabels]
        @sublabels = []
      when [:labels, :label, :images, :image]
        @image = Image.new
      when [:labels, :label, :sublabels, :label]
        @sublabel = LabelReference.new
      when [:labels, :label, :parentLabel]
        @parent_label = LabelReference.new
      end
    end

    def end_element(name)
      case @path
      when [:labels, :label]
        @handler.call(@label)
      when [:labels, :label, :images]
        @label.images = @images
      when [:labels, :label, :images, :image]
        @images << @image
      when [:labels, :label, :sublabels]
        @label.sublabels = @sublabels
      when [:labels, :label, :sublabels, :label]
        @sublabel.name = @text
        @sublabels << @sublabel
      when [:labels, :label, :parentLabel]
        @parent_label.name = @text
        @label.parent_label = @parent_label
      when [:labels, :label, :urls]
        @label.urls = @urls
      when [:labels, :label, :urls, :url]
        @urls << @text
      when [:labels, :label, :id]
        @label.id = @text.to_i
      when [:labels, :label, :name]
        @label.name = @text
      when [:labels, :label, :contactinfo]
        @label.contact_info = @text
      when [:labels, :label, :profile]
        @label.profile = @text
      when [:labels, :label, :data_quality]
        @label.data_quality = @text
      end

      @path.pop
    end

    def attr(name, value)
      case @path
      when [:labels, :label, :parentLabel]
        @parent_label.id = value.to_i
      when [:labels, :label, :sublabels, :label]
        @sublabel.id = value.to_i
      when [:labels, :label, :images, :image]
        case name
        when :type then @image.type = value
        when :uri then @image.uri = value
        when :uri150 then @image.uri150 = value
        when :width then @image.width = value.to_i
        when :height then @image.height = value.to_i
        end
      end
    end

    def text(value)
      @text = value
    end
  end
end
