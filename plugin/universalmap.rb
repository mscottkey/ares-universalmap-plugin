$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Universalmap

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
        when 'create'
          return UmapCreateCmd
        when 'list'
          return UmapListCmd
        when 'view'
          return UmapViewCmd
        when 'addtoken'
          return UmapAddTokenCmd
        when 'move'
          return UmapMoveCmd
        when 'addobject'
          return UmapAddObjectCmd
        when 'reveal'
          return UmapRevealCmd
        when 'reindex'
          return UmapReindexCmd
        when 'hide'
          return UmapHideCmd
        when 'delete'
          return UmapDeleteCmd
        when 'uninstall'
          return UmapUninstallCmd
        when nil
          return UmapListCmd  # Optional: show help instead
        else
          client.emit_failure "Unknown umap command. Try `help umap`."
          return nil
        end
      end
      return nil
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
      return nil
    end

    def load
      Global.logger.warn "🔥 Plugin load() method was called for universalmap"

      UniversalMapObject.all.each { |o| o.update(visibility: o.visibility) }
      UniversalMapToken.all.each { |t| t.update(visibility: t.visibility) }
      Global.logger.info "✅ universalmap: Reindexed tokens and objects on plugin load."
    end

  end
end
