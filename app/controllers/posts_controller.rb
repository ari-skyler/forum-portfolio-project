class PostsController < ApplicationController
  # GET: /posts
  get "/posts" do
    @posts = Post.all
    erb :"/posts/index"
  end
  # GET: /posts/new
  get "/posts/new" do
    erb :"/posts/new"
  end
  # POST: /posts
  post "/posts" do
    if is_logged_in? && !params[:title].blank? && !params[:content].blank?
      params[:slug] = slugify(params[:title])
      Post.create(params)
      redirect "/posts"
    else
      redirect "/posts"
    end
  end
  # GET: /posts/slug
  get "/posts/:slug" do
    erb :"/posts/show"
  end
  # GET: /posts/5/edit
  get "/posts/:id/edit" do
    erb :"/posts/edit"
  end
  # PATCH: /posts/5
  patch "/posts/:id" do
    redirect "/posts/:id"
  end
  # DELETE: /posts/5/delete
  delete "/posts/:id/delete" do
    redirect "/posts"
  end
end
