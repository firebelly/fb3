Refinery::Core::Engine.routes.draw do

  # Admin routes
  namespace :firebelly, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/firebelly" do
      resources :highlights, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
