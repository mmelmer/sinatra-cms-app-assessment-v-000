class ApartmentsController < ApplicationController

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
    apartment_id
    @user = User.find_by(:id => @apartment.user_id)
    if logged_in
      @viewer = logged_in_user
    else
      @viewer = User.new
    end
    erb :'/apartments/show'
  end

  get '/apartments/:id/edit' do
    apartment_id
    @user = User.find_by(:id => @apartment.user_id)
    if author?
      erb :'/apartments/edit'
    else
      redirect "/apartments"
    end
  end

  patch '/apartments/:id' do
    apartment_id
    @apartment.update(:content => params[:content], :headline => params[:headline], :price => params[:price])
    @apartment.save
    redirect "/apartments/#{@apartment.id}"
  end

  get '/apartments/:id/delete' do
    apartment_id
    @user = User.find_by(:id => @apartment.user_id)
    if author?
      @apartment.delete
      redirect "/apartments"
    else
      redirect "/apartments"
    end
  end  

end