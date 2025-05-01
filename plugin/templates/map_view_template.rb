module AresMUSH
  module UniversalMap
    class MapViewTemplate < ErbTemplateRenderer
      attr_accessor :map

      def initialize(map)
        self.map = map
        super File.dirname(__FILE__) + "/map_view_template.erb"
      end

      def render_abstract
        zones = Hash.new { |h, k| h[k] = { tokens: [], objects: [] } }
      
        (map.tokens + map.objects).each do |thing|
          zone = thing.zone || "Unknown"
          next if map.fog_enabled && !map.revealed.include?(zone)
      
          if thing.is_a?(AresMUSH::UniversalMapToken)
            zones[zone][:tokens] << thing
          else
            zones[zone][:objects] << thing
          end
        end
      
        zone_order = Global.read_config("universal_map", "abstract", "zone_order")
        descs = Global.read_config("universal_map", "abstract", "zone_descriptions") || {}
      
        zone_order.map do |zone|
          if map.fog_enabled && !map.revealed.include?(zone)
            "%lh\n%xh[#{zone}]%xn\n  %xk(Fogged)%xn\n%lf"
          else
            tokens = zones[zone][:tokens].map { |t| "- %xh#{t.name}%xn" }
            objects = zones[zone][:objects].map { |o| "  • #{MapHelpers.format_object(o.object_type)}" }
            <<~ZONE.strip
              %lh
              %xh[#{zone}]%xn
              %xc#{descs[zone]}%xn
              %xgTokens:%xn
              #{tokens.join("\n")}
              %xbObjects:%xn
              #{objects.join("\n")}
              %lf
            ZONE
          end
        end.compact.join("\n")
      end
      
    
      def render_grid
        return "This map is not in grid mode." if map.mode != "grid"

        width = Global.read_config("universal_map", "grid", "default_width") || 10
        height = Global.read_config("universal_map", "grid", "default_height") || 10

        # Determine boundaries dynamically if needed later
        grid = Array.new(height) { Array.new(width, ".") }

        # Overlay fog (if any)
        if map.fog_enabled
          (0...height).each do |y|
            (0...width).each do |x|
              coord = "#{x},#{y}"
              unless map.revealed.include?(coord)
                grid[y][x] = "░"
              end
            end
          end
        end

        # Place objects
        map.objects.each do |obj|
          next if map.fog_enabled && !map.revealed.include?("#{obj.x},#{obj.y}")
          grid[obj.y][obj.x] = object_symbol(obj.object_type)
        end

        # Place tokens
        map.tokens.each do |tok|
          next if map.fog_enabled && !map.revealed.include?("#{tok.x},#{tok.y}")
          grid[tok.y][tok.x] = token_symbol(tok.name)
        end

        grid.map { |row| row.join(" ") }.join("\n")
      end

      def object_symbol(type)
        {
          "crate" => "C",
          "wall" => "W",
          "tree" => "T"
        }[type] || "O"
      end

      def token_symbol(name)
        name[0,1].upcase
      end
    end
  end
end
