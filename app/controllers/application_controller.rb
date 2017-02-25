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
      @user = User.find_by(:id => @apartment.user_id)
      if logged_in
        @viewer = logged_in_user
      else
        @viewer = User.new
      end
      erb :'/apartments/show'
  end

  get '/apartments/:id/edit' do
    @apartment = Apartment.find_by(:id => params[:id])
    @user = User.find_by(:id => @apartment.user_id)
    if @user.id == logged_in_user.id
      erb :'/apartments/edit'
    else
      erb :'/apartments/index'
    end
  end

  patch '/apartments/:id' do
    @apartment = Apartment.find_by(:id => params[:id])
    @apartment.update(:content => params[:content], :headline => params[:headline], :price => params[:price])
    @apartment.save
    redirect "/apartments/#{@apartment.id}"
  end

  get '/apartments/:id/delete' do
    @apartment = Apartment.find_by(:id => params[:id])
    if @apartment.user_id == logged_in_user.id
      @apartment.delete
      redirect "/apartments"
    else
      redirect "/apartments"
    end
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
    @sale = Sale.find_by(:id => params[:id])
    @user = User.find_by(:id => @sale.user_id)
    if logged_in
      @viewer = logged_in_user
    else
      @viewer = User.new
    end
    erb :'/sales/show'
  end

  get '/for_sale/:id/edit' do
    @sale = Sale.find_by(:id => params[:id])
    @user = User.find_by(:id => @sale.user_id)
    if @user.id == logged_in_user.id
      erb :'/sales/edit'
    else
      erb :'/sales/index'
    end
  end

  patch '/for_sale/:id' do
    @sale = Sale.find_by(:id => params[:id])
    @sale.update(:content => params[:content], :headline => params[:headline], :price => params[:price])
    @sale.save
    redirect "/for_sale/#{@sale.id}"
  end

  get '/for_sale/:id/delete' do
    @sale = Sale.find_by(:id => params[:id])
    if @sale.user_id == logged_in_user.id
      @sale.delete
      redirect "/for_sale"
    else
      redirect "/for_sale"
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
    @wanted = Wanted.find_by(:id => params[:id])
    @user = User.find_by(:id => @wanted.user_id)
    if logged_in
      @viewer = logged_in_user
    else
      @viewer = User.new
    end
    erb :'/wanteds/show'
  end

  get '/wanted/:id/edit' do
    @wanted = Wanted.find_by(:id => params[:id])
    @user = User.find_by(:id => @wanted.user_id)
    if @user.id == logged_in_user.id
      erb :'/wanteds/edit'
    else
      erb :'/wanteds/index'
    end
  end

  patch '/wanted/:id' do
    @wanted = Wanted.find_by(:id => params[:id])
    @wanted.update(:content => params[:content], :headline => params[:headline])
    @wanted.save
    redirect "/wanted/#{@wanted.id}"
  end

  get '/wanted/:id/delete' do
    @wanted = Wanted.find_by(:id => params[:id])
    if @wanted.user_id == logged_in_user.id
      @wanted.delete
      redirect "/wanted"
    else
      redirect "/wanted"
    end
  end 

end