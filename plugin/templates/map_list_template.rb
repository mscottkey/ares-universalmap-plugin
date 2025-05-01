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
        Universalmap.safe_tokens(map).size
      end
      
      def object_count(map)
        Universalmap.safe_objects(map).size
      end
    end
  end
end
