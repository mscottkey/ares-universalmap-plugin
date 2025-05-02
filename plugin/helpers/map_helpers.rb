module AresMUSH
  module Universalmap
    module MapHelpers

      def self.format_object(object_key, web: false)
        config = Global.read_config("universal_map_objects", object_key)
        return object_key.titlecase if config.nil?

        label = config["label"] || object_key.titlecase
        icon = config["icon"]

        if web && icon
          "#{icon} #{label}"
        else
          label
        end
      end

      def self.safe_tokens(map)
        UniversalMapToken.all.select { |t| t.map_id == map.id }
      rescue => e
        Global.logger.warn "🔧 Failed to fetch tokens (fallback): #{e}"
        []
      end

      def self.safe_objects(map)
        UniversalMapObject.all.select { |o| o.map_id == map.id }
      rescue => e
        Global.logger.warn "🔧 Failed to fetch objects (fallback): #{e}"
        []
      end

    end
  end
end
