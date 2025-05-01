module AresMUSH
  module UniversalMap
    class MapListCmd
      include CommandHandler

      def handle
        maps = UniversalMapGrid.all.to_a.sort_by { |m| m.created_at }.reverse
        if maps.empty?
          client.emit "No maps found."
          return
        end
        template = MapListTemplate.new(maps)
        client.emit template.render
      end      
    end
  end
end
