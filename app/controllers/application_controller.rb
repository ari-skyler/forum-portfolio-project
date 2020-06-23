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
      slug = string.downcase.gsub(" ", "-")
      i = 1
      t = true
      while t
        if i == 2
          slug = slug + "-" + i.to_s
        elsif i > 2
          slug[-1] = i.to_s
        end
        post = Post.find_by(slug: slug)
        if !post
          t = false
        end
        i+=1
      end
      return slug
    end
    def is_logged_in?
      !!session[:user_id]
    end
    def current_user
      User.find_by_id(session[:user_id])
    end
    def belongs_to_current_user(object)
      !!(current_user.id == object.user_id)
    end
  end
end
