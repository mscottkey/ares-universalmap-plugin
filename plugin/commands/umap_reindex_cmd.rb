
module AresMUSH
  module Universalmap
    class UmapReindexCmd
      include CommandHandler

      def check_admin
        return t('dispatcher.not_allowed') unless enactor.is_admin?
      end

      def handle
        token_count = 0
        object_count = 0

        UniversalMapToken.all.each do |t|
          t.update(visibility: t.visibility)
          token_count += 1
        end

        UniversalMapObject.all.each do |o|
          o.update(visibility: o.visibility)
          object_count += 1
        end

        client.emit_success "✅ Reindexed #{token_count} tokens and #{object_count} objects."
      end
    end
  end
end
