Rails.application.routes.draw do

  resources :all_city_program_data

  get 'set_language/english'

  get 'set_language/spanish'

  get 'set_language/polish'

  get ':controller/:action'
  get ':locale/:controller/:action'

  # post ':controller/:action'
  # post ':locale/:controller/:action'

  # twilio english 
  get("/twilio", { :controller => "send_text", :action => "send_text_message"})
  post('/', { :controller => 'twilio', :action => 'text'})
  post 'twilio/voice', defaults: { format: 'xml' }

  # twilio spanish 
  get("/twilio_spanish", { :controller => "send_text", :action => "send_spanish_text_message"})
  post('/twilio_spanish', { :controller => 'twilio_spanish', :action => 'text'})
  
  #twilio test
  get("/twilio_test", { :controller => "send_text", :action => "send_test_text_message"})
  post('/twilio_test', { :controller => 'twilio_testing', :action => 'text'})
   
  #static pages 
  root to: "pages#homepage"
  get('/about_us', { :controller => 'pages', :action => 'about_us' })
  get('/how_mrelief_works', { :controller => 'pages', :action => 'how_mrelief_works' })
  get('/press_release', { :controller => 'pages', :action => 'press_release' })
  get('/public-template', { :controller => 'pages', :action => 'public_template' })
  get('/press_emails', { :controller => 'pages', :action => 'press_emails' })


  # all programs at once
  get("/filter", { :controller => "pages", :action => "filter" })
  get("/filtered_programs", { :controller => "pages", :action => "filtered_programs" })
  post("/community_resources", { :controller => "pages", :action => "community_resources" })

  get "early_learning_programs", to: "early_learning_programs#new", as: "early_learning"
  post "early_learning_programs_results", to: "early_learning_programs#create", as: "early_learning_programs_results"
  get "early_learning_more_results/:id", to: "early_learning_programs#more_results", as: "more_results"
  get "early_learning_privacy_policy", to: "early_learning_programs#early_learning_privacy_policy"

  # print
  get('/snap_eligibilities/print/:id', :controller => 'snap_eligibilities', :action => 'print')

  # documents
  get("/snap_documents", { :controller => "snap_eligibilities", :action => "documents" })
  get("/rental_documents", { :controller => "rental_assistances", :action => "documents" })

  # clear session
  get("/session_clear", {:controller => "pages", :action => "session_clear"})

  # email list
  get 'email_lists/opt_in', to: 'email_lists#opt_in'
  get 'email_lists/confirm_email', to: 'email_lists#confirm_email'
  get 'email_lists/send_journalist_emails', to: 'email_lists#send_journalist_emails'

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

  resources :aabd_cashes

  resources :tanifs

  resources :service_centers

  resources :medicare_cost_sharings

  resources :organizations

  resources :laf_centers


end
