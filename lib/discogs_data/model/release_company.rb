module DiscogsData
  module Model
    ReleaseCompany = Struct.new(:label_reference, :entity_type, :entity_type_name, :catalog_number, :resource_url) do
      def label_id
        label_reference&.id
      end

      def label_name
        label_reference&.name
      end
    end
  end
end
