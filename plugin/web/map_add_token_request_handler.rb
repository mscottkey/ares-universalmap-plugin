module AresMUSH
  module Universalmap
    class MapAddTokenRequestHandler
      def handle(request)
        error = Website.check_login(request)
        return error if error

        map = UniversalMapGrid[request.args[:map_id]]
        return { c_error: t('map.not_found') } if !map

        name = request.args[:name]
        return { c_error: t('map.token_name_required') } if name.blank?

        coords = request.args[:coords]
        if map.mode == 'grid'
          return { c_error: t('map.invalid_coords') } if coords.blank? || !(coords =~ /^\d+,\d+$/)
          x, y = coords.split(',').map(&:to_i)
        else
          return { c_error: t('map.missing_zone') } if coords.blank?
          zone = coords
        end

        map.tokens << UniversalMapToken.create(
          map: map,
          name: name,
          x: x,
          y: y,
          zone: zone
        )

        {
          message: t('map.token_added', name: name),
          token: {
            name: name,
            x: x,
            y: y,
            zone: zone
          }
        }
      end
    end
  end
end
