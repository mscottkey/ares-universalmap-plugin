module AresMUSH
  module UniversalMap
    class MapAddObjectCmd
      include CommandHandler

      attr_accessor :map_id, :object_type, :location

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.map_id = integer_arg(args.arg1)
        self.object_type = downcase_arg(args.arg2)
        self.location = args.arg3
      end

      def required_args
        [ self.map_id, self.object_type, self.location ]
      end

      def check_map_exists
        return t('map.not_found') if !UniversalMapGrid[self.map_id]
        return nil
      end

      def handle
        map = UniversalMapGrid[self.map_id]

        if map.mode == 'grid'
          return client.emit_failure t('map.invalid_coords') if !(self.location =~ /^\d+,\d+$/)
          x, y = self.location.split(',').map(&:to_i)
          zone = nil
        else
          x, y = nil, nil
          zone = self.location
        end

        map.objects << UniversalMapObject.create(
          map: map,
          object_type: self.object_type,
          x: x,
          y: y,
          zone: zone
        )

        label = MapHelpers.format_object(self.object_type)
        client.emit_success t('map.object_added', name: label)
      end
    end
  end
end
