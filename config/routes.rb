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

  get("/twilio", { :controller => "send_text", :action => "send_text_message"})
  post('/', { :controller => 'twilio', :action => 'text'})

  get("/twilio_spanish", { :controller => "send_text", :action => "send_spanish_text_message"})
  post('/twilio_spanish', { :controller => 'twilio_spanish', :action => 'text'})

  post 'twilio/voice', defaults: { format: 'xml' }

  get('/all_city_testing', { :controller => 'pages', :action => 'all_city_testing' })

  get('/about_us', { :controller => 'pages', :action => 'about_us' })
  # get('/contact_us', { :controller => 'pages', :action => 'contact_us' })
  get('/how_mrelief_works', { :controller => 'pages', :action => 'how_mrelief_works' })
  get('/press_release', { :controller => 'pages', :action => 'press_release' })


  get("/", { :controller => "pages", :action => "homepage" })
  get("/filter", { :controller => "pages", :action => "filter" })
  get("/filtered_programs", { :controller => "pages", :action => "filtered_programs" })
  post("/community_resources", { :controller => "pages", :action => "community_resources" })

  get('/snap_eligibilities/print/:id', :controller => 'snap_eligibilities', :action => 'print')

  get("/snap_documents", { :controller => "snap_eligibilities", :action => "documents" })

  get("/rental_documents", { :controller => "rental_assistances", :action => "documents" })



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


end
