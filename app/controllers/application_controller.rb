require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "assessment_secret"
  end

  helpers do 
    def logged_in_user
      User.find_by(:id => session[:user_id])
    end 

    def logged_in
      !!session[:user_id]
    end

    def author?
      @user.id == logged_in_user.id
    end
  end

  get '/' do
    erb :index
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user !=nil && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/'
    else
      flash[:message] = "incorrect username or password."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/signup' do
    erb :'/users/create'
  end

  post '/signup' do
    if (params[:username] == "") || (params[:email] == "") || (params[:password] == "")
      redirect '/signup'
    else
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect '/'
    end
  end

  get '/my_ads' do
    if logged_in
      @user = logged_in_user
      @apartments = []
      Apartment.all.each {|apt| @apartments << apt if apt.user_id == @user.id}
      @sales = []
      Sale.all.each {|sale| @sales << sale if sale.user_id == @user.id}
      @wanteds = []
      Wanted.all.each {|wanted| @wanteds << wanted if wanted.user_id == @user.id}
      erb :'users/index'
    else
      redirect '/login'
    end
  end

  get '/create_ad' do
    erb :create
  end

end