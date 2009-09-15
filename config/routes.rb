ActionController::Routing::Routes.draw do |map|
  map.resources :messages, :new => {:reply => :get}, :except => [:show, :destroy]

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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  map.home '', :controller => 'main', :action => 'index'

#  map.journals 'journals/:id/:record_id',
#                  :controller => 'member', :action => 'journal'
#  map.night_journals 'night_journals/:id/:record_id',
#                  :controller => 'member', :action => 'night_journal'

  map.journal 'journal/:id/:year/:month/:day',
                  :controller => 'member',
                  :action => 'journal',
                  :year  => nil,
                  :month => nil,
                  :day => nil,
                  :requirements => {
                    :year => /(\d{4})/,  
                    :day => /(\d{1,2})/,  
                    :month => /(\d{1,2})/ 
                  } 

  map.night_journal 'night_journal/:id/:year/:month/:day',
                  :controller => 'member',
                  :action => 'night_journal',
                  :year  => nil,
                  :month => nil,
                  :day => nil,
                  :requirements => {
                    :year => /(\d{4})/,  
                    :day => /(\d{1,2})/,  
                    :month => /(\d{1,2})/ 
                  } 

  map.member 'member/:action/:id', :controller => 'member'
  map.friend 'friend/:action/:id', :controller => 'friend'
  map.user 'user/:action/:id', :controller => 'user'
  map.word 'word/:action/:id', :controller => 'great_word'
  map.mobile 'mobile/:action/:id', :controller => 'mobile'
  map.namepk_method 'namepk/:action/game/:id/method/:method_id', :controller => 'namepk'
  map.namepk 'namepk/:action/:id', :controller => 'namepk'


  map.connect "main/reset_password/:reset_code",
                :conditions => { :method => :get },
                :controller => "main",
                :action => "reset_password"

  map.connect "main/confirm_email/:confirm_code",
                :conditions => { :method => :get },
                :controller => "main",
                :action => "confirm_email"

  map.main 'main/:action/:id', :controller => 'main'
  # See how all your routes lay out with "rake routes"
  #For customize the image upload view
  map.connect '/javascripts/tiny_mce/plugins/curblyadvimage/image.htm', :controller => 'tiny_mce_photos', :action => 'curblyadvimage'


  # Install the default routes as the lowest priority.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
