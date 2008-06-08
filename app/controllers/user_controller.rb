require 'rubygems'
require 'hatena/api/auth'

class UserController < ApplicationController
  layout "basic", :only => :index
  
  def index
    @users = Image.find_by_sql("SELECT user_name FROM images GROUP BY user_name")
  end

  def login
    if ($willustrator_config[:offline])
      test_user = $willustrator_config[:offline_username]
      session[:user_name] = test_user
      redirect_to "/#{test_user}/"
      return
    end
    
    hatena_auth = Hatena::API::Auth.new(:api_key => $willustrator_config[:hatena_api_key],
                                        :secret => $willustrator_config[:hatena_api_secret])
    if params.has_key?(:cert)
      begin
        user = hatena_auth.login(params[:cert])
        session[:user_name] = user['name']
        redirect_to "/#{user['name']}/"
      rescue Hatena::API::AuthError => e
        render :text => 'Auth Error'
      end
    else
      redirect_to hatena_auth.uri_to_login.to_s
    end
  end

  def logout
    session[:user_name] = nil
    redirect_to '/'
  end
end
