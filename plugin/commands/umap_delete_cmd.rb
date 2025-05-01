module AresMUSH
  module UniversalMap
    class UmapDeleteCmd
      include CommandHandler

      attr_accessor :map_id

      def parse_args
        self.map_id = integer_arg(cmd.args)
      end

      def required_args
        [ self.map_id ]
      end

      def check_admin
        return t('dispatcher.not_allowed') if !enactor.is_admin?
        return nil
      end

      def check_map_exists
        return t('map.not_found') if !UniversalMapGrid[self.map_id]
        return nil
      end

      def handle
        map = UniversalMapGrid[self.map_id]
        map.tokens.each(&:delete)
        map.objects.each(&:delete)
        map.delete

        client.emit_success t('map.deleted', id: self.map_id)
      end
    end
  end
end
