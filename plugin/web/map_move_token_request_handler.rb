module AresMUSH
  module UniversalMap
    class MapMoveTokenRequestHandler
      def handle(request)
        token_id = request.args[:id]
        token = AresMUSH::UniversalMapToken[token_id]
        return { error: "Token not found." } unless token

        x = request.args[:x]
        y = request.args[:y]
        zone = request.args[:zone]

        token.update(
          x: x,
          y: y,
          zone: zone
        )

        { success: true }
      end
    end
  end
end
