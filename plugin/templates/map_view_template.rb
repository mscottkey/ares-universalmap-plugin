module AresMUSH
  module Universalmap
    class MapViewTemplate < ErbTemplateRenderer
      attr_accessor :map

      def initialize(map)
        self.map = map
        super File.dirname(__FILE__) + "/map_view_template.erb"
      end

      def render_abstract
        zones = Hash.new { |h, k| h[k] = { tokens: [], objects: [] } }

        (MapHelpers.safe_tokens(map) + MapHelpers.safe_objects(map)).each do |thing|
          zone = thing.zone || "Unknown"
          next if map.fog_enabled && !map.revealed.include?(zone)

          if thing.is_a?(AresMUSH::UniversalMapToken)
            zones[zone][:tokens] << thing
          else
            zones[zone][:objects] << thing
          end
        end

        zone_order = Global.read_config("universal_map", "abstract", "zone_order") || zones.keys.sort
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
              #{tokens.any? ? tokens.join("\n") : "  (none)"}
              %xbObjects:%xn
              #{objects.any? ? objects.join("\n") : "  (none)"}
              %lf
            ZONE
          end
        end.compact.join("\n")
      end

      def render_grid
        return "This map is not in grid mode." if map.mode != "grid"

        width = Global.read_config("universal_map", "grid", "default_width") || 10
        height = Global.read_config("universal_map", "grid", "default_height") || 10

        grid = Array.new(height) { Array.new(width, ".") }

        # Overlay fog
        if map.fog_enabled
          (0...height).each do |y|
            (0...width).each do |x|
              coord = "#{x},#{y}"
              grid[y][x] = "░" unless map.revealed.include?(coord)
            end
          end
        end

        Global.logger.debug "🌫️ Fog is #{map.fog_enabled}, revealed: #{map.revealed}"

        # Place objects
        MapHelpers.safe_objects(map).each do |obj|
          Global.logger.debug "📦 Evaluating object: #{obj.inspect}"
        
          unless valid_coords?(obj.x, obj.y, width, height)
            Global.logger.warn "❌ Skipped: invalid coords x=#{obj.x}, y=#{obj.y}"
            next
          end
        
          coord = "#{obj.x},#{obj.y}"
          if map.fog_enabled && !map.revealed.include?(coord)
            Global.logger.warn "⛔ Skipped due to fog: #{coord}"
            next
          end
        
          symbol = object_symbol(obj.object_type)
          Global.logger.debug "✅ Placing #{obj.object_type} (#{symbol}) at [#{obj.x},#{obj.y}] on map #{map.id}"
          grid[obj.y][obj.x] = symbol
        end
        

        # Place tokens
        MapHelpers.safe_tokens(map).each do |tok|
          next unless valid_coords?(tok.x, tok.y, width, height)
          coord = "#{tok.x},#{tok.y}"
          next if map.fog_enabled && !map.revealed.include?(coord)
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
        name.to_s[0,1].upcase
      end

      def valid_coords?(x, y, width, height)
        if x.nil? || y.nil? || !x.is_a?(Integer) || !y.is_a?(Integer)
          Global.logger.warn "MapViewTemplate: Invalid coords (nil or non-integer): x=#{x.inspect}, y=#{y.inspect}"
          return false
        end

        unless x.between?(0, width - 1) && y.between?(0, height - 1)
          Global.logger.warn "MapViewTemplate: Out-of-bounds object at x=#{x}, y=#{y}"
          return false
        end

        true
      end
    end
  end
end
