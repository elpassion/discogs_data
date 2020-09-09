module DiscogsData
  module Model
    class Artist < Struct.new(:id, :name, :real_name, :profile, :data_quality, :name_variations, :aliases, :images, :urls, :members, :groups)
      def primary_image
        images&.detect { |image| image.type == "primary" }
      end

      def secondary_images
        images&.find_all { |image| image.type == "secondary" }
      end

      def member_ids
        members&.map(&:id)
      end

      def group_ids
        groups&.map(&:id)
      end
    end
  end
end
