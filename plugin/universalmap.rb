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
        when 'create' then UmapCreateCmd
        when 'list' then UmapListCmd
        when 'view' then UmapViewCmd
        when 'addtoken' then UmapAddTokenCmd
        when 'move' then UmapMoveCmd
        when 'addobject' then UmapAddObjectCmd
        when 'reveal' then UmapRevealCmd
        when 'hide' then UmapHideCmd
        when 'delete' then UmapDeleteCmd
        when 'uninstall' then UmapUninstallCmd
        when nil
          return UmapListCmd  # or a help display template
        else
          client.emit_failure "Unknown umap command. Try `help umap`."
          return nil
        end
      end
      nil
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
