module AresMUSH
  module Universalmap
    class MapMoveTokenRequestHandler
      def handle(request)
        error = Website.check_login(request)
        return error if error

        token = UniversalMapToken[request.args[:token_id]]
        return { c_error: t('map.token_not_found') } if !token

        coords = request.args[:coords]
        if token.map.mode == 'grid'
          return { c_error: t('map.invalid_coords') } if coords.blank? || !(coords =~ /^\d+,\d+$/)
          token.update(x: coords.split(',')[0].to_i, y: coords.split(',')[1].to_i)
        else
          return { c_error: t('map.missing_zone') } if coords.blank?
          token.update(zone: coords)
        end

        {
          message: t('map.token_moved', name: token.name)
        }
      end
    end
  end
end
