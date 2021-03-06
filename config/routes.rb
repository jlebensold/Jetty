Jetty::Application.routes.draw do
  # Account
  devise_for(:users,
    :path => '/users',
    :path_names => { :sign_in => 'login', :sign_out => 'logout' },
    :controllers => { :sessions => 'sessions' })

  # Omniauth pure
  match "/signin" => "users#signin"
  match "/signout" => "users#signout"

  match '/auth/:service/callback' => 'services#create' 
  match '/auth/failure' => 'services#failure'

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  
  resources :contents
  resources :courses
  
  resources :payments
  
  match "users",               :to => "user", :via =>"post"
  match "users/register",      :to => "users#register", :via =>"post"

  match "zencoder/:id/:label", :to => "zencoder#index"
  
  match 'purchases' , :to => "p#purchases"
  match "p/:id",      :to => "p#preview", :via =>"get"

  root :to => 'home#index';

  
  match "courses/",            :to => "courses#index",  :via => "get"
  match "courses/new",         :to => "courses#new",    :via => "get"
  match "courses/update",      :to => "courses#update", :via =>"post"


  match "contents/",            :to => "contents#index", :via => "get"
  match "contents/new",         :to => "contents#new",   :via => "get"
  match "contents/rename",      :to => "contents#save" , :via =>"post"
  match "contents/retrieve",    :to => "contents#upload"
  match "contents/postprocess", :to => "contents#postprocess" , :via =>"post"
  match "contents/delete", :to => "contents#delete"


  namespace :user do
    root :to => "users#index"
  end

  match ':controller(/:action(/:id(.:format)))'

end
