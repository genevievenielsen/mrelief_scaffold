Rails.application.routes.draw do

  resources :all_city_program_data

  get 'set_language/english'

  get 'set_language/spanish'

  get 'set_language/polish'

  get ':controller/:action'
  get ':locale/:controller/:action'


  resources :aabd_cashes

  resources :tanifs

  resources :service_centers

  resources :medicare_cost_sharings

  resources :organizations

  resources :laf_centers

  post('/', { :controller => 'twilio', :action => 'text'})
  post('/twilio_spanish', { :controller => 'twilio', :action => 'text'})
  post 'twilio/voice', defaults: { format: 'xml' }

  get('/all_city_testing', { :controller => 'pages', :action => 'all_city_testing' })

  get('/about_us', { :controller => 'pages', :action => 'about_us' })
  # get('/contact_us', { :controller => 'pages', :action => 'contact_us' })
  get('/how_mrelief_works', { :controller => 'pages', :action => 'how_mrelief_works' })
  get('/press_release', { :controller => 'pages', :action => 'press_release' })

  get("/", { :controller => "pages", :action => "homepage" })

  get("/twilio", { :controller => "send_text", :action => "send_text_message"})

  get('/all_city_programs_with_tanif', { :controller => 'all_city_programs', :action => 'new_with_tanif' })
  post('/all_city_programs_with_tanif', { :controller => 'all_city_programs', :action => 'create_with_tanif' })



  resources :contact, only: [:index, :create]

  resources :wics

  resources :visions

  resources :snap_eligibility_seniors

  resources :snap_eligibilities

  resources :rta_free_rides

  resources :rental_assistances

  resources :programs

  resources :medicaids

  resources :housing_assistances

  resources :head_starts

  resources :family_nutritions

  resources :early_head_starts

  resources :dentals

  resources :child_care_vouchers

  resources :auto_repair_assistances

  resources :all_kids

  resources :all_city_programs


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
