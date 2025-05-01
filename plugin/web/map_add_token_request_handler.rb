module AresMUSH
  module UniversalMap
    class MapAddTokenRequestHandler
      def handle(request)
        map_id = request.args[:map_id]
        map = AresMUSH::UniversalMap[map_id]
        return { error: "Map not found." } unless map

        name = request.args[:name]
        x = request.args[:x]
        y = request.args[:y]
        zone = request.args[:zone]
        icon_url = request.args[:icon_url]
        visibility = request.args[:visibility] || "public"

        AresMUSH::UniversalMapToken.create(
          name: name,
          x: x,
          y: y,
          zone: zone,
          icon_url: icon_url,
          visibility: visibility,
          map: map
        )

        { success: true }
      end
    end
  end
end
