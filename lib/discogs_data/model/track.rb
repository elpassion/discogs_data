module DiscogsData
  module Model
    class Track < Struct.new(:position, :title, :duration, :artists)
    end
  end
end
