module DiscogsData
  class Label < Struct.new(:id, :name, :contact_info, :profile, :data_quality, :urls, :images, :sublabels, :parent_label)
    def primary_image
      images&.detect { |image| image.type == "primary" }
    end

    def secondary_images
      images&.find_all { |image| image.type == "secondary" }
    end

    def sublabel_ids
      sublabels&.map(&:id)
    end

    def parent_label_id
      parent_label&.id
    end
  end
end
