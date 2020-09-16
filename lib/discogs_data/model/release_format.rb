module DiscogsData
  module Model
    class ReleaseFormat < Struct.new(:name, :qty, :text, :descriptions)
    end
  end
end
