module DiscogsData
  module Model
    class Video < Struct.new(:title, :description, :src, :duration, :embed)
    end
  end
end
