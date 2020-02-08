require "./config/environment"
require "./app/models/user"
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    # binding.pry
    if params[:username].size > 0 && params[:password].size > 0
      user = User.new(username: params[:username], password: params[:password])
      session[:user_id] = user.id
		  redirect("/login")
    else
      redirect("/failure")
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    # binding.pry
    if params[:username].size > 0 && params[:password].size > 0
      user = User.find_by(username: params[:username])
      session[:user_id] = user.id
		  redirect("/account")
    else
      redirect("/failure")
    end
    
    # binding.pry

  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
