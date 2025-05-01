module AresMUSH
  module UniversalMap
    class UmapUninstallCmd
      include CommandHandler

      def check_admin
        return t('dispatcher.not_allowed') unless enactor.is_admin?
        return nil
      end

      def handle
        if !cmd.confirmed?
          client.emit "⚠️ This will permanently delete all Universal Map data. To confirm, type:\n%xh@map/uninstall/confirm%xn"
          return
        end

        count = 0
        UniversalMap.all.each do |map|
          map.tokens.each(&:delete)
          map.objects.each(&:delete)
          map.delete
          count += 1
        end

        client.emit_success t('map.uninstalled', count: count)
      end
    end
  end
end
