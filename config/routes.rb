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
  
  resources :settings, only: [:edit, :update, :show] do
    collection do
      post 'addcurrency' # /settings/addcurrency
      get 'syncInvoices'
      post 'addEmailTriggers'
    end
  end
  
  resources :tours
  resources :password_resets
  resources :email_templates
    
  resources :suppliers do
    collection do
#      get 'customersearch'  # /enquires/customersearch
      get 'suppliersearch'  # /suppliers/suppliersearch
    end
  end
  
  resources :agents  do
    collection do
      get 'agentsearch'  # /agents/suppliersearch
    end
  end
  
  resources :customers do
    collection do
      get 'addnote'  # /customers/addnote
    end
  end

  resources :enquiries do
    collection do
      get 'customersearch'  # /enquires/customersearch
      get 'carriersearch'  # /enquires/carriersearch
      get 'destinationsearch'  # /enquires/destinationsearch
      get 'stopoversearch'  # /enquires/stopoversearch
      get 'addnote'  # /enquires/addnote
      post 'addbooking'  # /enquires/addbooking
      post "webenquiry"
      get "confirmation"
    end
  end
  
  resources :bookings do
    resources :invoices do
      collection do
        get 'addxeroinvoice'  # /bookings/addxeroinvoice
        get 'getxeroinvoice'
        get 'addxeropayment'
        get 'changexeroinvoice'
        get 'supplierInvoice'
        get 'syncInvoice'
        post 'createSupplier'
        #get 'pdfRemaining'
        match ':id/pdfRemaining', to: 'invoices#pdfRemaining',   as: 'pdfRemaining' ,via: 'get'
        match ':id/pdfDeposit', to: 'invoices#pdfDeposit',   as: 'pdfDeposit' ,via: 'get'
        match 'showSupplier/:id', to: 'invoices#showSupplier',   as: 'showSupplier' ,via: 'get'
       # match 'suppliers/new', to: 'invoices#supplierInvoice',   as: 'supplierInvoice' ,via: 'get'
      end
    end
  end
  
  match '/pxpaymentsuccess',   to: 'invoices#pxpaymentsuccess',   via: 'get'
  match '/pxpaymentfailure',   to: 'invoices#pxpaymentfailure',   via: 'get'
  
  resources :sessions, only: [:new, :create, :destroy]

  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/noaccess',   to: 'static_pages#noaccess',   via: 'get'
  match '/dashboard',   to: 'static_pages#dashboard' ,   via: 'get'
  match '/dashboard_list',   to: 'static_pages#dashboard_list' ,   via: 'get'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
  get 'static_pages/currencysearch'
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
  
  post "emails/post"

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
