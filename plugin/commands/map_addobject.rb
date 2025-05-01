module AresMUSH
  module UniversalMap
    class MapAddObjectCmd
      include CommandHandler

      attr_accessor :type, :location

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.type = args.arg1
        self.location = args.arg2
      end

      def required_args
        [ self.type, self.location ]
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
          AresMUSH::UniversalMapObject.create(type: self.type, x: x, y: y, map: map)
        else
          AresMUSH::UniversalMapObject.create(type: self.type, zone: self.location, map: map)
        end

        client.emit_success "Object added."
      end
    end
  end
end
