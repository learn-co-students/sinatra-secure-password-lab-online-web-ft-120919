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
    user = User.new(username: params[:username], password: params[:password], balance: 0)
    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    @error = check_error
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post '/transaction' do
    user = User.find_by(id: session[:user_id])
    if !params[:amount] || params[:amount].to_f <= 0
      session[:error] = "Please provide an amount greater than 0." 
    else
      if params[:transaction] == "deposit"
        binding.pry
        user.balance += params[:amount].to_f
        user.save
        binding.pry
      elsif params[:transaction] == "withdrawal"
        if params[:amount].to_f > user.balance
          session[:error] = "You cannot withdraw more than your current balance."
        else
          user.balance -= params[:amount].to_f
          user.save
        end
      else #no transaction selected
        session[:error] = "Please select a transaction type."
      end
    end
    redirect '/account'
  end

  def check_error
    error = session[:error]
    if error
      session[:error] = nil
      error
    else
      nil
    end
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
