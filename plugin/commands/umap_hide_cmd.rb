module AresMUSH
  module Universalmap
    class UmapHideCmd
      include CommandHandler

      attr_accessor :location

      def parse_args
        self.location = cmd.args
      end

      def required_args
        [ self.location ]
      end

      def handle
        map = AresMUSH::UniversalMap.find(:title, enactor_room.name).first
        if !map
          client.emit_failure "No map found for this room."
          return
        end

        if map.mode == "grid" && self.location.include?(",")
          x, y = self.location.split(',').map(&:to_i)
          key = "grid_#{x}_#{y}"
        else
          key = "zone_#{self.location.downcase}"
        end

        fog = map.fog_data || {}
        fog[key] = true
        map.update(fog_data: fog)

        client.emit_success "Re-fogged #{self.location} on the map."
      end
    end
  end
end
