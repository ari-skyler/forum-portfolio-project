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
      if current_user
        !!(current_user.id == object.user_id)
      end
    end
    def undelta(delta)
      delta = JSON.parse(delta)
      entries = delta["ops"]

      html = ""
      i = 0
      while i < entries.length
        if !!entries[i + 1] && !!entries[i + 1]["attributes"] && !!entries[i]["insert"] && !!entries[i + 1]["attributes"]["header"]
            content = "<h#{entries[i + 1]["attributes"]["header"]}>#{entries[i]["insert"]}</h#{entries[i + 1]["attributes"]["header"]}>"
          #lists
        elsif !!entries[i + 1] && !!entries[i + 1]["attributes"] && entries[i]["insert"] && entries[i + 1]["attributes"]["list"]
            content = ""
            if !!entries[i + 1] && !!entries[i + 1]["attributes"]
              if !!entries[i - 1] && !!entries[i - 1]["attributes"] && !entries[i - 1]["attributes"]["list"]
                content << "<ul><li>#{entries[i]["insert"]}</li>"
              elsif !!entries[i + 3] && !!entries[i + 3]["attributes"] && !entries[i + 3]["attributes"]["list"]
                  content << "<li>#{entries[i]["insert"]}</li></ul>"
              elsif !entries[i + 2]
                content << "<li>#{entries[i]["insert"]}</li></ul>"
              else
                content << "<li>#{entries[i]["insert"]}</li>"
              end
            end

        elsif entries[i]["insert"] && entries[i]["attributes"] && !(!!entries[i]["attributes"]["list"] || (!!entries[i + 1] && !!entries[i + 1]["attributes"] && !!entries[i + 1]["attributes"]["list"])) && !entries[i]["insert"].empty?
          open = ""
          close = []
          if entries[i]["attributes"]["bold"]
            open << "<b>"
            close << "</b>"
          end
          if entries[i]["attributes"]["italic"]
            open << "<i>"
            close << "</i>"
          end
          if entries[i]["attributes"]["underline"]
            open << "<u>"
            close << "</u>"
          end
          content = open + entries[i]["insert"] + close.reverse().join("")
        else
          content = entries[i]["insert"]
        end
          html << content
        i+=1
      end
      html.gsub("\n", "<br>").gsub("<p></p>","")
    end
  end
end
