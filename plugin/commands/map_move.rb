module AresMUSH
  module UniversalMap
    class MapMoveCmd
      include CommandHandler

      attr_accessor :name, :location

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = args.arg1
        self.location = args.arg2
      end

      def required_args
        [ self.name, self.location ]
      end

      def handle
        token = AresMUSH::UniversalMapToken.find(:name, self.name).first
        if (!token)
          client.emit_failure "Token not found."
          return
        end

        loc_data = self.location.split(',')
        if token.map.mode == "grid" && loc_data.length == 2
          token.update(x: loc_data[0].to_i, y: loc_data[1].to_i)
        else
          token.update(zone: self.location)
        end

        client.emit_success "Token moved."
      end
    end
  end
end
