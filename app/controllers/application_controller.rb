require './config/environment'

class ApplicationController < Sinatra::Base

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
      redirect '/signup'
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
      redirect '/login'
    end
  end

  get '/listings' do
    erb :current_listings
  end

  get '/apartments' do
    erb :'/apartments/index'
  end

  post '/apartments' do
    @user = logged_in_user
    @apartment = Apartment.create(params["apartment"]) 
    @apartment.user_id = @user.id
    @apartment.save
    redirect '/apartments'
  end

  get '/apartments/new' do
    if logged_in
      erb :'apartments/create'
    else
      redirect '/login'
    end
  end

  get '/apartments/:id' do
      @apartment = Apartment.find_by(:id => params[:id])
      erb :'/apartments/show'
  end

  get '/apartments/:id/edit' do
    @apartment = Apartment.find_by(:id => params[:id])
    erb :'/apartments/edit'
  end

  patch '/apartments/:id' do
    @apartment = Apartment.find_by(:id => params[:id])
    @apartment.update(:content => params[:content], :headline => params[:headline], :price => params[:price])
    @apartment.save
    redirect "/apartments/#{@apartment.id}"
  end


  get '/for_sale' do
    erb :'/sales/index'
  end

  get '/for_sale/new' do
    if logged_in
      erb :'sales/create'
    else
      redirect '/login'
    end
    
  end

  post '/for_sale' do
    @user = logged_in_user
    @sale = Sale.create(params["sale"]) 
    @sale.user_id = @user.id
    @sale.save
    redirect '/for_sale'
  end

  get '/for_sale/:id' do
    if logged_in
      @sale = Sale.find_by(:id => params[:id])
      erb :'/sales/show'
    else
      redirect '/login'
    end
  end

  get '/wanted' do
    erb :'/wanteds/index'
  end

  get '/wanted/new' do
    if logged_in
      erb :'/wanteds/create'
    else
      redirect '/login'
    end
  end

  post '/wanted' do
    @user = logged_in_user
    @wanted = Wanted.create(params["wanted"]) 
    @wanted.user_id = @user.id
    @wanted.save
    redirect '/wanted'
  end

  get '/wanted/:id' do
    if logged_in
      @wanted = Wanted.find_by(:id => params[:id])
      erb :'/wanteds/show'
    else
      redirect '/login'
    end
  end


end