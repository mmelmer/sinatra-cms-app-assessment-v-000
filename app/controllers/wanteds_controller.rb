class WantedsController < ApplicationController

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
    if params[:wanted][:headline] == ""
      redirect '/wanted/new'
    else
      @user = logged_in_user
      @wanted = Wanted.create(params["wanted"]) 
      @wanted.user_id = @user.id
      @wanted.save
      redirect '/wanted'
    end
  end

  get '/wanted/:id' do
    wanted_id
    @user = User.find_by(:id => @wanted.user_id)
    if logged_in
      @viewer = logged_in_user
    else
      @viewer = User.new
    end
    erb :'/wanteds/show'
  end

  get '/wanted/:id/edit' do
    wanted_id
    @user = User.find_by(:id => @wanted.user_id)
    if author?
      erb :'/wanteds/edit'
    else
      redirect "/wanted"
    end
  end

  patch '/wanted/:id' do
    wanted_id
    @wanted.update(:content => params[:content], :headline => params[:headline])
    @wanted.save
    redirect "/wanted/#{@wanted.id}"
  end

  get '/wanted/:id/delete' do
    wanted_id
    @user = User.find_by(:id => @wanted.user_id)
    if author?
      @wanted.delete
      redirect "/wanted"
    else
      redirect "/wanted"
    end
  end 

end