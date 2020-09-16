module DiscogsData
  module Model
    class ReleaseArtist < Struct.new(:artist_reference, :anv, :join, :role, :tracks)
      def artist_id
        artist_reference&.id
      end

      def artist_name
        artist_reference&.name
      end
    end
  end
end
