module AresMUSH
  module UniversalMap
    class MapRequestHandler
      def handle(request)
        map_id = request.args[:id]
        map = AresMUSH::UniversalMap[map_id]

        return { error: "Map not found." } unless map

        {
          id: map.id,
          title: map.title,
          mode: map.mode,
          fog_enabled: map.fog_enabled,
          tokens: map.tokens.map do |t|
            {
              id: t.id,
              name: t.name,
              x: t.x,
              y: t.y,
              zone: t.zone,
              icon_url: t.icon_url,
              visibility: t.visibility
            }
          end,
          objects: map.objects.map do |o|
            {
              id: o.id,
              type: o.type,
              x: o.x,
              y: o.y,
              zone: o.zone,
              visibility: o.visibility
            }
          end,
          fog_data: map.fog_data
        }
      end
    end
  end
end
