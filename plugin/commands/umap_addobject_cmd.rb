module AresMUSH
  module Universalmap
    class UmapCreateCmd
      include CommandHandler

      attr_accessor :title, :options

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.title = titlecase_arg(args.arg1)
        self.options = downcase_arg(args.arg2 || "")
      end

      def required_args
        [ self.title ]
      end

      def handle
        mode = self.options.include?("grid") ? "grid" : "abstract"
        fog = self.options.include?("fog")

        map = Universalmap.create(
          title: self.title,
          mode: mode,
          fog_enabled: fog,
          revealed: []
        )

        client.emit_success t('map.created', title: self.title, id: map.id)
      end
    end
  end
end
