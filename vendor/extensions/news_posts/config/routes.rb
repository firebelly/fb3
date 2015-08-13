Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :news_posts, :path => 'news' do
    get "tagged/:tag" =>"news_posts#tagged", :as => 'news_tagged'
    resources :news_posts, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :news_posts, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :news_posts, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
