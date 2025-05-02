module AresMUSH
  module Universalmap
    class UmapViewCmd
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
        if (!map)
          client.emit_failure t('map.not_found')
          return
        end
      
        url = "#{Global.read_config('website', 'portal_url')}/map/#{map.id}"
        client.emit_success t('map.view_url', url: url)
        client.emit MapViewTemplate.new(map).render
      end
    end
  end
end
