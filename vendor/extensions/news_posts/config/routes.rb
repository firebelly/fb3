Refinery::Core::Engine.routes.draw do

  get '/feed' => 'news_posts#feed', :defaults => { :format => 'atom' }, :as => 'news_feed'
  get "tagged/:id" =>"news_posts#tagged", :as => 'news_tagged'

  # Frontend routes
  namespace :news_posts, :path => 'news' do
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
