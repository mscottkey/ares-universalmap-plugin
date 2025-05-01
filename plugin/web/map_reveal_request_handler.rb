module AresMUSH
  module UniversalMap
    class MapRevealRequestHandler
      def handle(request)
        map_id = request.args[:map_id]
        location = request.args[:location]
        map = AresMUSH::UniversalMap[map_id]
        return { error: "Map not found." } unless map

        key = location_key(map.mode, location)
        fog = map.fog_data || {}
        fog[key] = false
        map.update(fog_data: fog)

        { success: true }
      end

      def location_key(mode, location)
        if mode == "grid" && location.include?(",")
          x, y = location.split(',').map(&:to_i)
          "grid_#{x}_#{y}"
        else
          "zone_#{location.downcase}"
        end
      end
    end
  end
end
