module DiscogsData
  module Model
    class TrackArtist < Struct.new(:artist_reference, :anv, :join, :role, :tracks)
    end
  end
end
