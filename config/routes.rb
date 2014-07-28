Reprobus::Application.routes.draw do
  root  'static_pages#home' 
  
  get "password_resets/new"
  post "versions/:id/revert" => "versions#revert", as:   
       "revert_version"

  resources :users do
    collection do
      get 'usersearch'  # /users/usersearch  
    end
  end
  
  resources :tours
  resources :password_resets
  
  resources :customers do 
    collection do
      get 'addnote'  # /enquires/customersearch  
    end
  end

  resources :enquiries do 
    collection do
      get 'customersearch'  # /enquires/customersearch  
      get 'carriersearch'  # /enquires/carriersearch  
    end
  end 
  resources :sessions, only: [:new, :create, :destroy]

  match '/about',   to: 'static_pages#about',   via: 'get' 
  match '/dashboard',   to: 'static_pages#dashboard' ,   via: 'get'   
  match '/dashboard_list',   to: 'static_pages#dashboard_list' ,   via: 'get'   
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  get "admin/carriers/export"
  get "admin/destinations/export"
  get "admin/stopovers/export"
  get "admin/carriers/import"
  get "admin/destinations/import"
  get "admin/stopovers/import"
  post "admin/carriers/importfile"
  post "admin/destinations/importfile"
  post "admin/stopovers/importfile"
  
  namespace :admin do 
    get '', to: 'dashboard#index', as: '/' 
    resources :carriers 
    resources :destinations 
    resources :stopovers 
  end 
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
