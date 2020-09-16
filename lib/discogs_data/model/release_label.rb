module DiscogsData
  module Model
    class ReleaseLabel < Struct.new(:label_reference, :catalog_number)
      def label_id
        label_reference&.id
      end

      def label_name
        label_reference&.name
      end
    end
  end
end
