module AresMUSH
  module UniversalMap
    class MapRequestHandler
      def handle(request)
        error = Website.check_login(request)
        return error if error

        map = UniversalMap[request.args[:id]]
        return { c_error: t('map.not_found') } if !map

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
              zone: t.zone
            }
          end,
          objects: map.objects.map do |o|
            {
              id: o.id,
              type: o.object_type,
              label: MapHelpers.format_object(o.object_type, web: true),
              x: o.x,
              y: o.y,
              zone: o.zone
            }
          end
        }
      end
    end
  end
end
