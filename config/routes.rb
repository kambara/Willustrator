ActionController::Routing::Routes.draw do |map|
  #
  # index
  #
  map.connect(
              '',
              :controller => 'image',
              :action => 'index'
              )

  #
  # login/logout
  #
  map.connect(
              'login',
              :controller => 'user',
              :action => 'login'
              )
  
  map.connect(
              'logout',
              :controller => 'user',
              :action => 'logout'
              )

  #
  # redirect
  #
  map.connect(
              'proxy',
              :controller => 'image',
              :action => 'proxy'
              )

  #
  # json
  #
  map.connect(
              'json/user/:user_name',
              :controller => 'json',
              :action => 'user'
              )

  map.connect(
              'json/user2/:user_name',
              :controller => 'json',
              :action => 'user2'
              )

  map.connect(
              'json/tag/:name',
              :controller => 'json',
              :action => 'tag'
              )

  map.connect(
              'json/new_image',
              :controller => 'json',
              :action => 'new_image'
              )

  #
  # image
  #
  map.connect(
              'image/:action/:md5id',
              :controller => 'image',
              :requirements => {:md5id => /([0-9a-f]{32}|\d{1,3})/}
              )

  map.connect(
              'image/:md5id',
              :controller => 'image',
              :action => 'show',
              :requirements => {:md5id => /([0-9a-f]{32}|\d{1,3})/}
              )

  map.connect(
              'image/:action',
              :controller => 'image'#,
              )

  #
  # tag
  #
  map.connect(
              'tag/:action/:id',
              :controller => 'tag',
              :requirements => {:action => /(add|destroy)/}
              )

  map.connect(
              'tag/:name',
              :controller => 'image',
              :action => 'tag'
              )
  map.connect('tag',
              :controller => 'tag',
              :action => 'index'
             )

  #
  # user page
  #
  map.connect(
              ':user_name/:tag',
              :controller => 'image',
              :action => 'user',
              :requirements => {:user_name => /[\w_-]+/,
                                :tag => /[\S]+/}
              )
  
  map.connect(
              ':user_name/',
              :controller => 'image',
              :action => 'user',
              :requirements => {:user_name => /[\w_-]+/}
              )
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
