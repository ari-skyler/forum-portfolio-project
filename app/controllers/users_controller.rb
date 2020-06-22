class UsersController < ApplicationController
  get '/users/:username' do
    if is_logged_in?
      @user = User.find_by(username: params[:username])
      erb :'/users/account'
    else
      @user = User.find_by(username: params[:username])
      erb :'/users/show'
    end
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
    if params[:username].include?("@")
      user = User.find_by(email: params[:username])
    else
      user = User.find_by(username: params[:username])
    end
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
  patch '/users/:username/update' do
    user = User.find_by(username: params[:username])
    if !params[:link].blank?
      user.update(link: params[:link])
      redirect '/users/' + user.username
    elsif !params[:bio].blank?
      user.update(bio: params[:bio])
      redirect '/users/' + user.username
    else
      redirect '/users/' + user.username
    end
  end
end
