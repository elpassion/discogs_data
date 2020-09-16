module DiscogsData
  module Model
    class ReleaseTrack < Struct.new(:position, :title, :duration, :artists, :extra_artists, :sub_tracks)
    end
  end
end
