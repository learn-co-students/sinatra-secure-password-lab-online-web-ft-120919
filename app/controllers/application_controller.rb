require "./config/environment"
require "./app/models/user"
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
    #make sure form is filled out with username and password
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
    else
      #check if user already exists
      user = User.find_by(username: params[:username])
      if !!user
        redirect "/login"
      else
        #use params to create new user
        User.create(username: params[:username], password: params[:password])
        redirect "/login"
      end
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
    #find user by username
    user = User.find_by(username: params[:username])
    #if user exists and password authenticates through bcrypt
    if user && user.authenticate(params[:password])
      #set session user id
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
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
