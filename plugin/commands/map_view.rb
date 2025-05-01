module AresMUSH
  module UniversalMap
    class MapViewCmd
      include CommandHandler

      attr_accessor :map_id

      def parse_args
        self.map_id = cmd.args
      end

      def required_args
        [ self.map_id ]
      end

      def handle
        map = AresMUSH::UniversalMap[self.map_id]
        if (!map)
          client.emit_failure "Map not found."
          return
        end

        url = "#{Website.portal_url}/map/#{map.id}"
        client.emit_success "View map '#{map.title}' here: #{url}"
      end
    end
  end
end
