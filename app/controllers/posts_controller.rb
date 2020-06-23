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
      params[:user_id] = current_user.id
      Post.create(params)
      redirect "/posts"
    else
      redirect "/posts"
    end
  end
  # GET: /posts/slug
  get "/posts/:slug" do
    @post = Post.find_by(slug: params[:slug])
    if @post
      if current_user.id == @post.user_id
        @belongs_to_current_user = true
      else
        @belongs_to_current_user = false
      end
      erb :"/posts/show"
    else
      erb:'/oops'
    end
  end
  # GET: /posts/5/edit
  get "/posts/:id/edit" do
    @post = Post.find_by_id(params[:id])
    erb :"/posts/edit"
  end
  # PATCH: /posts/5
  patch "/posts/:id" do
    post = Post.find_by_id(params[:id])
    params[:slug] = slugify(params[:title])
    params.delete("_method")
    post.update(params)
    redirect "/posts/" + post.slug
  end
  # DELETE: /posts/5/delete
  delete "/posts/:id/delete" do
    Post.destroy(params[:id])
    redirect "/posts"
  end
end
