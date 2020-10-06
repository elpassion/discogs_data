module DiscogsData
  module Model
    Release = Struct.new(:id, :status, :images, :artists, :title, :labels, :extra_artists, :formats, :genres, :styles, :country, :released, :notes, :data_quality, :master_id, :master_main_release, :tracklist, :identifiers, :videos, :companies) do
      def primary_image
        images&.detect { |image| image.type == "primary" }
      end

      def secondary_images
        images&.find_all { |image| image.type == "secondary" }
      end
    end
  end
end
