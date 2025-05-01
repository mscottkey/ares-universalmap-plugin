module AresMUSH
  module UniversalMap
    class MapAddObjectRequestHandler
      def handle(request)
        error = Website.check_login(request)
        return error if error

        map_id = request.args[:map_id]
        object_type = request.args[:type]
        coords = request.args[:coords]

        map = UniversalMapGrid[map_id]
        return { c_error: t('map.not_found') } if !map

        if map.mode == 'grid'
          if coords.blank? || !(coords =~ /^\d+,\d+$/)
            return { c_error: t('map.invalid_coords') }
          end
          x, y = coords.split(',').map(&:to_i)
        else
          if coords.blank?
            return { c_error: t('map.missing_zone') }
          end
          zone = coords
        end

        object_label = MapHelpers.format_object(object_type)
        map.objects << UniversalMapObject.create(
          map: map,
          object_type: object_type,
          x: x,
          y: y,
          zone: zone
        )

        {
          message: t('map.object_added', name: object_label),
          object: {
            type: object_type,
            label: object_label,
            x: x,
            y: y,
            zone: zone
          }
        }
      end
    end
  end
end
