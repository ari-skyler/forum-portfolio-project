require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "top_secret"
  end

  get "/" do
    erb :welcome
  end
  not_found do
    status 404
    erb :oops
  end
  helpers do
    def slugify(string)
      string.gsub(" ", "-")
    end
    def is_logged_in?
      !!session[:user_id]
    end
    def current_user
      User.find_by_id(session[:user_id])
    end
  end
end
