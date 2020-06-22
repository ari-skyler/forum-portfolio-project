class UsersController < ApplicationController
  get '/users/:username' do
    @user = User.find_by(username: params[:username])
    erb :'/users/account'
  end
  get '/signup' do
    if !is_logged_in?
      erb :'users/signup'
    else
      redirect to '/'
    end
  end
  post '/signup' do
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect to '/'
    else
      redirect '/signup'
    end
  end
  get '/login' do
    if !session[:user_id]
      erb :'users/login'
    else
      redirect to '/'
    end
  end
  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/'
    else
      redirect '/login'
    end
  end
  get '/logout' do
    if !session[:user_id]
      redirect '/login'
    else
      session.clear
      redirect to '/login'
    end
  end
  post '/logout' do
    session.clear
    redirect to '/login'
  end
end
