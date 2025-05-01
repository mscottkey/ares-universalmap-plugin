module AresMUSH
  module UniversalMap
    class MapListCmd
      include CommandHandler

      def handle
        maps = UniversalMapGrid.all.sort_by(:created_at, :desc)
        template = MapListTemplate.new(maps)
        client.emit template.render
      end
    end
  end
end
