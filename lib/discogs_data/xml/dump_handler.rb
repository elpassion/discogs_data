require "forwardable"
require "ox"
require_relative "artists_handler"
require_relative "labels_handler"
require_relative "releases_handler"

module DiscogsData
  module XML
    class DumpHandler < ::Ox::Sax
      HANDLER_IMPLEMENTATIONS = {
          labels:   LabelsHandler,
          artists:  ArtistsHandler,
          releases: ReleasesHandler
      }

      def initialize(entity_callback, limit: nil)
        @entity_callback = entity_callback
        @limit           = limit
        @count           = 0
        @path            = []
      end

      def start_element(name)
        raise UnknownDumpFormat unless HANDLER_IMPLEMENTATIONS.has_key?(name)

        extend(HANDLER_IMPLEMENTATIONS[name])

        start_element(name)
      end

      def end_element(name)
      end

      def attr(name, str)
      end

      def text(value)
        @text = value
      end

      private

      def on_entity(entity)
        @count += 1

        raise ReadLimitReached if @limit && @count > @limit

        @entity_callback.call(entity)
      end
    end
  end
end
