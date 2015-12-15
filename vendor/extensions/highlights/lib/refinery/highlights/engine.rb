module Refinery
  module Firebelly
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Firebelly

      engine_name :refinery_highlights

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "highlights"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.firebelly_admin_highlights_path }
          plugin.pathname = root
          plugin.menu_match = %r{refinery/firebelly/highlights(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Highlights)
      end
    end
  end
end
