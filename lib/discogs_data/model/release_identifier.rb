module DiscogsData
  module Model
    class ReleaseIdentifier < Struct.new(:type, :description, :value)
    end
  end
end
