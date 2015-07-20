module Refinery
  module Projects
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Projects

      engine_name :refinery_projects

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "project_industries"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.projects_admin_project_industries_path }
          plugin.pathname = root
          plugin.menu_match = %r{refinery/projects/project_industries(/.*)?$}
          plugin.hide_from_menu = true
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::ProjectIndustries)
      end
    end
  end
end
