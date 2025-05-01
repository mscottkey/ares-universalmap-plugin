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
      when 'umap'
        case cmd.switch
        when 'create' then MapCreateCmd
        when 'view' then MapViewCmd
        when 'addtoken' then MapAddTokenCmd
        when 'move' then MapMoveCmd
        when 'addobject' then MapAddObjectCmd
        when 'reveal' then MapRevealCmd
        when 'hide' then MapHideCmd
        when 'delete' then MapDeleteCmd
        when 'uninstall' then MapUninstallCmd
        else
          client.emit_failure "Unknown umap command. Try `help umap`."
          nil
        end
      end
    end
    
    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "umap"
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
