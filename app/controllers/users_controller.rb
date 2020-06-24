class UsersController < ApplicationController
  get '/users/:username' do
    @user = User.find_by(username: params[:username])
    if @user
      if @user == current_user && is_logged_in?
        erb :'/users/account'
      else
        erb :'/users/show'
      end
    else
      erb :oops
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
    if validate_input(params) == true
      user = User.new(params)
      if user.save
        session[:user_id] = user.id
        redirect to '/'
      else
        redirect '/signup'
      end
    else
      @message = validate_input(params)[1]
      erb :'/users/signup'
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
    if !!params[:link]
      user.update(link: params[:link])
      redirect '/users/' + user.username
    elsif !!params[:bio]
      user.update(delta: params[:delta])
      redirect '/users/' + user.username
    else
      redirect '/users/' + user.username
    end
  end
  helpers do
    def validate_input(params)
      if params.values.any?(&:blank?)
        return false, "You need to fill out all fields."
      elsif !alphanumeric?(params[:pre_username])
        return false, "Username should be alphanumeric only"
      elsif User.find_by(username: params[:pre_username].downcase)
        return false, "Username: '#{params[:pre_username]}' is already taken"
      elsif User.find_by(email: params[:email].downcase)
        return false, "There is already an account with the email: '#{params[:email]}'."
      elsif params[:password].length < 6
        return false, "Password should be 6 characters or more."
      elsif params[:password] != params[:confirm_password]
        return false, "Passwords do not match"
      else
        return true
      end
    end
  end
end
