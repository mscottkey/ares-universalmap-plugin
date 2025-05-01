module AresMUSH
  module UniversalMap
    class MapHideCmd
      include CommandHandler

      attr_accessor :map_id, :location

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.map_id = integer_arg(args.arg1)
        self.location = args.arg2
      end

      def required_args
        [ self.map_id, self.location ]
      end

      def check_map_exists
        return t('map.not_found') if !UniversalMap[self.map_id]
        return nil
      end

      def handle
        map = UniversalMap[self.map_id]
        map.revealed.delete(self.location)
        map.save
        client.emit_success t('map.hidden', area: self.location)
      end
    end
  end
end
