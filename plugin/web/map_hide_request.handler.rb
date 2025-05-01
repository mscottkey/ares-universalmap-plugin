module AresMUSH
  module Universalmap
    class MapHideRequestHandler
      def handle(request)
        error = Website.check_login(request)
        return error if error

        map = UniversalMapGrid[request.args[:map_id]]
        return { c_error: t('map.not_found') } if !map

        coords = request.args[:coords]
        return { c_error: t('map.missing_reveal_target') } if coords.blank?

        map.revealed.delete(coords)
        map.save

        {
          message: t('map.hidden', area: coords)
        }
      end
    end
  end
end
