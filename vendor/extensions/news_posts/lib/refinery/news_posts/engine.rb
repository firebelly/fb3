module Refinery
  module NewsPosts
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::NewsPosts

      engine_name :refinery_news_posts

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "news_posts"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.news_posts_admin_news_posts_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::NewsPosts)
      end
    end
  end
end
