Rails.application.routes.draw do

  devise_for :users, controllers: {
        registrations: 'users/registrations',
        sessions: 'users/sessions'
      }
  resources :articles do
    resources :comments
  end
  resources :lootquotient
  resources :events
  resources :wowchars

  root 'welcome#index'
  get 'raid' => 'raid#index'
  get 'lootlist' => 'lootlist#lootlist'
  get 'events' => 'events#index'
  get 'users/show'
  get 'users' => 'users#index'
  post 'users/mod' => 'users#mod'
  post 'users/raid' => 'users#raid'  
  get "notfound", to: "application#catch_404", via: :all
 	get "*path", to: "application#catch_404", via: :all
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
