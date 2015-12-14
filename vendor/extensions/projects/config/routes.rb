Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :projects, :path => 'work' do
    resources :projects, :path => '', :only => [:index, :show]
    post 'upload_images' => 'projects#upload_images', as: 'upload_images'
    post 'image_alt_update' => 'projects#image_alt_update', as: 'image_alt_update'
  end

  # Admin routes
  namespace :projects, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :projects, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end


  # Admin routes
  namespace :projects, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/projects" do
      resources :project_industries, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
