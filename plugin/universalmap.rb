$:.unshift File.dirname(__FILE__)

module AresMUSH
  module UniversalMap

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config('universal_map', 'shortcuts') || {}
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when 'map'
        case cmd.switch
        when 'create'
          return MapCreateCmd
        when 'view'
          return MapViewCmd
        when 'addtoken'
          return MapAddTokenCmd
        when 'move'
          return MapMoveCmd
        when 'addobject'
          return MapAddObjectCmd
        when 'reveal'
          return MapRevealCmd
        when 'hide'
          return MapHideCmd
        when 'delete'
          return MapDeleteCmd
        when 'uninstall'
          return MapUninstallCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "map"
        return MapRequestHandler
      when "mapToken"
        return MapAddTokenRequestHandler
      when "mapTokenMove"
        return MapMoveTokenRequestHandler
      when "mapObject"
        return MapAddObjectRequestHandler
      when "mapReveal"
        return MapRevealRequestHandler
      when "mapHide"
        return MapHideRequestHandler
      end
      nil
    end

  end
end
