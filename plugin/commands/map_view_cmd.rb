module AresMUSH
  module UniversalMap
    class MapViewCmd
      include CommandHandler

      attr_accessor :map_id

      def parse_args
        self.map_id = integer_arg(cmd.args)
      end

      def required_args
        [ self.map_id ]
      end

      def check_map_exists
        return t('map.not_found') if !UniversalMapGrid[self.map_id]
        return nil
      end

      def handle
        map = UniversalMapGrid[self.map_id]
        url = "#{Website.portal_url}/map/#{map.id}"
        client.emit_success t('map.view_url', url: url)
      end
    end
  end
end
