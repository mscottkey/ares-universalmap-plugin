module AresMUSH
  module Universalmap
    class MapRevealRequestHandler
      def handle(request)
        error = Website.check_login(request)
        return error if error

        map = UniversalMapGrid[request.args[:map_id]]
        return { c_error: t('map.not_found') } if !map

        coords = request.args[:coords]
        return { c_error: t('map.missing_reveal_target') } if coords.blank?

        if map.mode == 'grid'
          return { c_error: t('map.invalid_coords') } if !(coords =~ /^\d+,\d+$/)
        end

        map.revealed << coords unless map.revealed.include?(coords)
        map.save

        {
          message: t('map.revealed', area: coords)
        }
      end
    end
  end
end
