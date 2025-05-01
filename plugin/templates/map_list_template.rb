module AresMUSH
  module Universalmap
    class MapListTemplate < ErbTemplateRenderer

      attr_accessor :maps
      
      def initialize(maps)
        self.maps = maps
        super File.dirname(__FILE__) + "/map_list_template.erb"
      end

      def fog(map)
        map.fog_enabled ? "Yes" : "No"
      end

      def token_count(map)
        map.tokens.count
      end

      def object_count(map)
        map.objects.count
      end
    end
  end
end
