module AresMUSH
  module UniversalMap
    class MapAddObjectRequestHandler
      def handle(request)
        map_id = request.args[:map_id]
        map = AresMUSH::UniversalMap[map_id]
        return { error: "Map not found." } unless map

        AresMUSH::UniversalMapObject.create(
          type: request.args[:type],
          x: request.args[:x],
          y: request.args[:y],
          zone: request.args[:zone],
          visibility: request.args[:visibility] || "public",
          map: map
        )

        { success: true }
      end
    end
  end
end
