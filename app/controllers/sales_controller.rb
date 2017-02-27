class SalesController < ApplicationController

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
    if params[:sale][:headline] == ""
      flash[:message] = "your ad must have a title."
      redirect '/for_sale/new'
    else
      @user = logged_in_user
      @sale = Sale.create(params["sale"]) 
      @sale.user_id = @user.id
      @sale.save
      redirect '/for_sale'
    end
  end

  get '/for_sale/:id' do
    sales_id
    @user = User.find_by(:id => @sale.user_id)
    if logged_in
      @viewer = logged_in_user
    else
      @viewer = User.new
    end
    erb :'/sales/show'
  end

  get '/for_sale/:id/edit' do
    sales_id
    @user = User.find_by(:id => @sale.user_id)
    if author?
      erb :'/sales/edit'
    else
      redirect "/for_sale"
    end
  end

  patch '/for_sale/:id' do
    sales_id
    @sale.update(:content => params[:content], :headline => params[:headline], :price => params[:price])
    @sale.save
    redirect "/for_sale/#{@sale.id}"
  end

  get '/for_sale/:id/delete' do
    sales_id
    @user = User.find_by(:id => @sale.user_id)
    if author?
      @sale.delete
      redirect "/for_sale"
    else
      redirect "/for_sale"
    end
  end 

end