module AresMUSH
  module UniversalMap
    class MapCreateCmd
      include CommandHandler

      attr_accessor :title, :mode, :fog

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.title = args.arg1
        options = args.arg2 ? args.arg2.downcase : ""

        self.mode = options.include?("grid") ? "grid" : "abstract"
        self.fog = options.include?("fog")
      end

      def required_args
        [ self.title ]
      end

      def handle
        map = AresMUSH::UniversalMap.create(
          title: self.title,
          mode: self.mode,
          fog_enabled: self.fog,
          created_at: Time.now
        )

        client.emit_success "Map '#{map.title}' (#{map.mode}, Fog: #{map.fog_enabled}) created. ID: #{map.id}"
      end
    end
  end
end
