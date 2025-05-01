module AresMUSH
  module UniversalMap
    class MapAddTokenCmd
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
        map = AresMUSH::UniversalMap.find(:title, enactor_room.name).first
        if (!map)
          client.emit_failure "No map found for this scene."
          return
        end

        loc_data = self.location.split(',')
        if map.mode == "grid" && loc_data.length == 2
          x = loc_data[0].to_i
          y = loc_data[1].to_i
          AresMUSH::UniversalMapToken.create(name: self.name, x: x, y: y, map: map)
        else
          AresMUSH::UniversalMapToken.create(name: self.name, zone: self.location, map: map)
        end

        client.emit_success "Token added."
      end
    end
  end
end
