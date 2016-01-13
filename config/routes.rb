Reprobus::Application.routes.draw do
  root  'static_pages#home'
  
  match '/timed_out', to: 'static_pages#timed_out', as: :timed_out, via: :get
  
  get "password_resets/new"
  get "password_resets/new"
  post "versions/:id/revert" => "versions#revert", as:
       "revert_version"

  resources :password_resets
  resources :users
  
  resources :settings, only: [:edit, :update, :show] do
    collection do
      post 'addcurrency' # /settings/addcurrency
      get 'syncInvoices'
      post 'addEmailTriggers'
      get 'general'
      get 'integration'
      get 'email'
      get 'currency'
      get 'operation'
      get 'itinerary'
    end
  end

  get '/dropbox_authorize' => 'settings#db_authorize', as: 'dropbox_authorize'
  get '/dropbox_unauthorize' => 'settings#db_unauthorize', as: 'dropbox_unauthorize'
  get '/dropbox_path_change' => 'settings#db_path_change', as: 'dropbox_path_change'
  get '/dropbox_callback' => 'settings#db_callback', as: 'dropbox_callback'

  
  resources :email_templates
  resources :itinerary_templates do
    member do
      get 'copy'
    end
  end
  resources :itineraries do
    get 'printQuote'
    get 'printConfirmed'
    get 'emailQuote'
    member do
      get 'copy'
      get 'cancel'
      post 'revert_cancel'
      get 'details'
      get 'booking_history'
      get 'generate_supplier_documents'
    end
  end

  resources :booking_history, only: [:download] do
    member { get :download }
  end
  
  resources :itinerary_prices, only: [:new, :edit, :update, :create] do
    get 'printQuote'
    get 'emailQuote'
    get 'emailQuote_bulk'
    collection do
      match 'invoice/:id', to: 'itinerary_prices#invoice',   as: 'invoice' ,via: 'get'
      match 'invoice_supplier/:id', to: 'itinerary_prices#invoice_supplier',   as: 'invoice_supplier' ,via: 'get'
      match 'invoice_deposit/:id', to: 'itinerary_prices#invoice_deposit',   as: 'invoice_deposit' ,via: 'get'
      match 'invoice_deposit_old/:id', to: 'itinerary_prices#invoice_deposit_old',   as: 'invoice_deposit_old' ,via: 'get'
      match 'invoice_remaining/:id', to: 'itinerary_prices#invoice_remaining',   as: 'invoice_remaining' ,via: 'get'
      match 'payments/:id', to: 'itinerary_prices#payments',   as: 'payments' ,via: 'get'
    end
  end
    
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
        get 'getxeroinvoice'
        get 'supplierInvoice'
        post 'createSupplier'
        match 'showSupplier/:id', to: 'invoices#showSupplier',   as: 'showSupplier' ,via: 'get'
      end
    end
  end
  
  match '/pxpaymentsuccess',   to: 'invoices#pxpaymentsuccess',   via: 'get'
  match '/pxpaymentfailure',   to: 'invoices#pxpaymentfailure',   via: 'get'
  match '/changexeroinvoice/:id',   to: 'invoices#changexeroinvoice',  as: 'changexeroinvoice',  via: 'get'
  match '/addxeropayment/:id',   to: 'invoices#addxeropayment', as: 'addxeropayment',  via: 'get'
  match '/syncInvoice/:id',   to: 'invoices#syncInvoice', as: 'syncInvoice',  via: 'get'

  resources :sessions, only: [:new, :create, :destroy]

  match '/about',   to: 'static_pages#about',   via: 'get'
  get '/successful-pin-payment/:id',   to: 'static_pages#successful_pin_payment',  as: 'successful_pin_payment'
  
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
  get '/import_status', to: 'static_pages#import_status', as: 'import_status'
  get '/import_status_job/:id', to: 'static_pages#import_status_job', as: 'import_status_job'
  get '/import_status_rerun/:id', to: 'static_pages#import_status_rerun', as: 'import_status_rerun'

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
  get 'searches/template_search', to: 'searches#template_search'
  get 'searches/supplier_search'
  get 'searches/customer_search'
  get 'searches/country_search'
  get 'searches/destination_search'
  get 'searches/cruise_info_search'
  get 'searches/product_info_search'
  get 'searches/enquiry_search', to: 'searches#enquiry_search'
      
      
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :carriers
    resources :destinations do
      collection do
        post :search_by_name
      end
    end
    resources :countries
    resources :stopovers
  end

  namespace :products do
    get '', to: 'dashboard#index', as: '/'
    get '/:type/:original_product_id/copy' => 'products#copy'
    resources :tours, :controller => "products", :type => "Tour"
    resources :cruises, :controller => "products", :type => "Cruise"
    resources :transfers, :controller => "products", :type => "Transfer", :as => :transfers
    resources :hotels, :controller => "products", :type => "Hotel"
    resources :flights, :controller => "products", :type => "Flight"
  end
  match '/products', to: 'products/products#create',     via: 'post'
  match '/products/:id', to: 'products/products#update',     via: 'patch', :as => :current_product

  namespace :reports do
    get '', to: 'dashboard#index', as: '/'
    resources :enquiry, only: [:index]
    resources :booking_travel, only: [:index]
    resources :confirmed_booking, only: [:index]
    resources :supplier, only: [:index]
    resources :destination, only: [:index]
    resources :unconfirmed_booking, only: [:index]
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
