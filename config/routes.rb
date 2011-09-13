Jukebox::Application.routes.draw do

  ['index', 'upload', 'delete', 'current_song', 'next_song', 
    'vote_song_up', 'vote_song_down', 'vote_to_skip'].each do |m|
    match "player/#{m}", as: "#{m}"
    #get "player/#{m}.json"
  end

  ['listeners', 'send_message', 'login'].each do |m|
    match "chat/#{m}", as: "#{m}"
  end

  #match "listeners" => 'player#listener'
  #post "send_message" => 'player#send_message'
  #post 'get_gravatar_url' => 'player#get_gravatar_url'

  #get 'current_song_urls' => 'player#current_song_urls'
  #get 'next_song'        => 'player#next_song'
  #get 'vote_song_up'     => 'player#vote_song_up'
  #get 'vote_song_down'   => 'player#vote_song_down'
  #get 'vote_to_skip'     => 'player_vote_to_skip'

  match '/pusher/auth' => 'chat#auth'

  root :to => 'player#index'
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
  # match ':controller(/:action(/:id(.:format)))'
end
