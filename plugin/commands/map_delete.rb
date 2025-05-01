module AresMUSH
  module UniversalMap
    class MapDeleteCmd
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

        map.tokens.each(&:delete)
        map.objects.each(&:delete)
        map.delete

        client.emit_success "Map deleted."
      end
    end
  end
end
