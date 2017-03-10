class ApartmentsController < ApplicationController

  get '/apartments' do
    erb :'/apartments/index'
  end

  get '/apartments/new' do
    if logged_in
      erb :'apartments/create'
    else
      redirect '/login'
    end
  end

  post '/apartments' do
    if params[:apartment][:headline] == ""
      flash[:message] = "your ad must have a title."
      redirect '/apartments/new'
    else
      @user = logged_in_user
      @apartment = Apartment.create(params["apartment"]) 
      @apartment.user_id = @user.id
      @apartment.save
      redirect '/apartments'
    end
  end

  get '/apartments/:id' do
    apartment_id
    if logged_in
      @viewer = logged_in_user
    else
      @viewer = User.new
    end
    erb :'/apartments/show'
  end

  get '/apartments/:id/edit' do
    apartment_id
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
    if author?
      @apartment.delete
      redirect "/apartments"
    else
      redirect "/apartments"
    end
  end  

end