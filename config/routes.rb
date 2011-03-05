Jetty::Application.routes.draw do
  devise_for :users

  resources :administrators
  resources :contents
  resources :courses
  resources :users
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

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # match 'users/:id' => 'user#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
