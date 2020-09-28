require "ox"
require_relative "../model/image"
require_relative "../model/label"
require_relative "../model/label_reference"

module DiscogsData
  module XML
    module LabelsHandler
      def start_element(name)
        @path << name

        case @path.size
        when 2
          case name
          when :label then @label = {}
          end
        when 3
          case name
          when :parentLabel then @label[:parent_label] = {}
          when :urls,
               :images,
               :sublabels   then @label[name] = []
          end
        when 4
          case name
          when :image then @label[:images] << {}
          when :label then @label[:sublabels] << {}
          end
        end
      end

      def end_element(name)
        case @path.size
        when 2
          case name
          when :label then on_entity(@label)
          end
        when 3
          case name
          when :id           then @label[:id] = @text.to_i
          when :contactinfo  then @label[:contact_info] = @text
          when :parentLabel  then @label[:parent_label][:name] = @text
          when :name,
               :profile,
               :data_quality then @label[name] = @text
          end
        when 4
          case name
          when :url   then @label[:urls] << @text
          when :label then @label[:sublabels].last[:name] = @text
          end
        end

        @path.pop
      end

      def attr(name, value)
        case @path.last
        when :parentLabel
          @label[:parent_label][:id] = value.to_i if name == :id
        when :label
          @label[:sublabels].last[:id] = value.to_i if @path.size == 4
        when :image
          case name
          when :type,
               :uri,
               :uri150 then @label[:images].last[name] = value
          when :width,
               :height then @label[:images].last[name] = value.to_i
          end
        end
      end
    end
  end
end
