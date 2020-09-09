module DiscogsData
  module Model
    class Image < Struct.new(:type, :uri, :uri150, :width, :height)
    end
  end
end
