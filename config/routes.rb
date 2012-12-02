SocialDash::Application.routes.draw do
  devise_for :users
  root :to => 'users#dashboard'

  match 'auth/:provider/callback' => 'social_apps#create'

  resources 'social_apps',:only => [:show,:index] do
    member do
      get 'settings'
    end
  end

  post 'social_apps/:id/twitter/retweet' => 'twitter#retweet' ,:as => :twitter_retweet
  post 'social_apps/:id/twitter/reply' => 'twitter#reply' ,:as => :twitter_reply
  post 'social_apps/:id/twitter/update_settings' => 'twitter#update_settings', :as => :twitter_update_settings
  get 'social_apps/:id/twitter/search_results' => 'twitter#search_results', :as => :twitter_search_results
  post 'social_apps/:id/twitter/block' => 'twitter#block',:as => :twitter_block
  get 'social_apps/:id/twitter/unblocking' => 'twitter#blocking', :as => :twitter_blocking

  post 'social_apps/:id/facebook/like' => 'facebook#like' ,:as => :facebook_like
  post 'social_apps/:id/facebook/comment' => 'facebook#comment' ,:as => :facebook_comment
  post 'social_apps/:id/facebook/update_settings' => 'facebook#update_settings', :as => :facebook_update_settings
  post 'social_apps/:id/facebook/block' => 'facebook#block',:as => :facebook_block
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
