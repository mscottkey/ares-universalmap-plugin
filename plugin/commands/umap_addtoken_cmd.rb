module AresMUSH
  module Universalmap
    class UmapAddTokenCmd
      include CommandHandler

      attr_accessor :map_id, :name, :location

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.map_id = integer_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
        self.location = args.arg3
      end

      def required_args
        [ self.map_id, self.name, self.location ]
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

        UniversalMapToken.create(
          map: map,
          name: self.name,
          x: x,
          y: y,
          zone: zone
        )
        client.emit_success t('map.token_added', name: self.name)
      end
    end
  end
end
