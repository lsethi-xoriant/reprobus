Reprobus::Application.routes.draw do
  root  'static_pages#home'
  
  get "password_resets/new"
  post "versions/:id/revert" => "versions#revert", as:
       "revert_version"

  resources :users
  
  resources :settings, only: [:edit, :update, :show] do
    collection do
      post 'addcurrency' # /settings/addcurrency
      get 'syncInvoices'
      post 'addEmailTriggers'
    end
  end

  resources :password_resets
  resources :email_templates
  resources :itinerary_templates
  resources :itineraries
    
  resources :suppliers
  resources :agents
  
  resources :customers do
    collection do
      get 'addnote'  # /customers/addnote
    end
  end

  resources :enquiries do
    collection do
      get 'carriersearch'  # /enquires/carriersearch
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
  match '/snapshot',   to: 'static_pages#snapshot' ,   via: 'get'
  match '/dashboard_list',   to: 'static_pages#dashboard_list' ,   via: 'get'
  match '/import',   to: 'static_pages#import' ,   via: 'get'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
  match '/import_products',   to: 'static_pages#import_products' ,   via: 'post'
  match '/import_countries',   to: 'static_pages#import_countries' ,   via: 'post'  
  match '/import_destinations',   to: 'static_pages#import_destinations' ,   via: 'post'
  match '/import_suppliers',   to: 'static_pages#import_suppliers' ,   via: 'post'

  
  
  get "admin/carriers/export"
  get "admin/destinations/export"
  get "admin/stopovers/export"
  get "admin/countries/export"
  get "admin/carriers/import"
  get "admin/destinations/import"
  get "admin/stopovers/import"
  get "admin/countries/import"
  post "admin/carriers/importfile"
  post "admin/destinations/importfile"
  post "admin/stopovers/importfile"
  post "admin/countries/importfile"
  
  get 'searches/product'
  get 'searches/product_search'
  get 'searches/agent_search'
  get 'searches/user_search'
  get 'searches/currency_search'
  get 'searches/template_search'
  get 'searches/supplier_search'
  get 'searches/customer_search'
  get 'searches/country_search'
  get 'searches/destination_search'
      
      
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :carriers
    resources :destinations
    resources :countries
    resources :stopovers
  end

  namespace :products do
    get '', to: 'dashboard#index', as: '/'
    resources :tours, :controller => "products", :type => "Tour"
    resources :cruises, :controller => "products", :type => "Cruise"
    resources :transfers, :controller => "products", :type => "Transfer", :as => :transfers
    resources :hotels, :controller => "products", :type => "Hotel"
    resources :flights, :controller => "products", :type => "Flight"
  end
  match '/products', to: 'products/products#create',     via: 'post'
  match '/products/:id', to: 'products/products#update',     via: 'patch', :as => :current_product

  
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
