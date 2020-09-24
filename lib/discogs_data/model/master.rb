module DiscogsData
  module Model
    Master = Struct.new(:id, :main_release_id, :images, :artists, :genres, :styles, :year, :title, :data_quality, :videos, :notes)
  end
end
