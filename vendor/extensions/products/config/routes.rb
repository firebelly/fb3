Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :products, :path => 'store' do
    resources :products, :path => '', :only => [:index, :show]
    resources :carts, :path => 'cart', :only => [:index, :create, :update]
    resources :cart_items, :path => 'cart_item', :only => [:destroy]
  end

  # Admin routes
  namespace :products, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :products, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
