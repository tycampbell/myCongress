ActionController::Routing::Routes.draw do |map|

                 
  map.resources :pages
  map.resources :users
  
  #Allows URL to show the username instead of the id
  map.show_user '/user/:username', 
                :controller => 'users',
                :action => 'show_by_username'
                
  #protects the enable method from being called with a GET, must be PUT
  #The roles resource requires a user id first
  map.resources :users, :member => { :enable => :put }
  
  #Bills resources:
  map.resources :bills, :collection => {:admin => :get, 
                  :activity_bills => :get,
                  :new_bills => :get, 
                  :finished_bills => :get,
                  :vote_for => :post,
                  :vote_against => :post,
                  :show_admin => :get,
                  :add_tag => :post,
                  :remove_tag => :post} do |bill|
          bill.resources :comments
          bill.resources :summaries
  end
  
  #tag resourcse
  map.resources :tags
  
  #politicians resources
  map.resources :politicians
  #Allow URL to show name of politician instead of id
  map.show_politician 'politician/:username',
                :controller => 'politicians',
                :action => 'show_by_username'
  
  
  #HomePage:
  
  map.index '/', :controller => 'bills',
                  :action => 'index'

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
