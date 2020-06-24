class PostsController < ApplicationController
  # GET: /posts
  get "/posts" do
    if is_logged_in?
      @posts = Post.all.reverse
      erb :"/posts/index"
    else
      redirect '/login'
    end
  end
  # GET: /posts/new
  get "/posts/new" do
    erb :"/posts/new"
  end
  # POST: /posts
  post "/posts" do
    if is_logged_in? && !params[:raw_title].blank? && !params[:delta].blank?
      current_user.posts.create(params)
      redirect "/posts"
    else
      redirect "/posts"
    end
  end
  # GET: /posts/slug
  get "/posts/:slug" do
    @post = Post.find_by(slug: params[:slug])
    if @post
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
    if belongs_to_current_user(post)
      post.update(params)
    end
    redirect "/posts/" + post.slug
  end
  # DELETE: /posts/5/delete
  delete "/posts/:id/delete" do
    post = Post.find_by_id(params[:id])
    if belongs_to_current_user(post)
      post.comments.destroy_all
      post.destroy
    end
    redirect "/posts"
  end
end
