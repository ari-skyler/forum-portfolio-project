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
      params[:content] = undelta(params[:content])
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
      @comments = @post.comments
      erb :"/posts/show"
    else
      erb:'/oops'
    end
  end
  # GET: /posts/5/edit
  get "/posts/:slug/edit" do
    @post = Post.find_by(slug: params[:slug])
    if belongs_to_current_user(@post)
      erb :"/posts/edit"
    else
      erb :oops
    end
  end
  # PATCH: /posts/5
  patch "/posts/:slug" do
    post = Post.find_by(slug: params[:slug])
    if post.user_id == current_user.id
      params[:slug] = slugify(params[:title])
      params[:content] = undelta(params[:content])
      params.delete("_method")
      post.update(params)
    end
    redirect "/posts/" + post.slug
  end
  # DELETE: /posts/5/delete
  delete "/posts/:id/delete" do
    post = Post.find_by_id(params[:id])
    if post.user_id == current_user.id
      post.destroy
    end
    redirect "/posts"
  end
end
