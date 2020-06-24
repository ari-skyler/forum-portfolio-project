class CommentsController < ApplicationController
  # POST: /comments
  post "/comments/post/:post_id" do
    post = Post.find_by_id(params[:post_id])
    if post && is_logged_in?
      params[:user_id] = current_user.id
      params[:content] = undelta(params[:content])
      comment = Comment.create(params)
    end
    redirect "/posts/" + post.slug
  end
  get '/comments/:id/edit' do
    @comment = Comment.find_by_id(params[:id])
    if belongs_to_current_user(@comment)
      erb :'comments/edit'
    else
      erb :oops
    end
  end
  # PATCH: /comments/5
  patch "/comments/:id" do
    comment = Comment.find_by_id(params[:id])
    params[:content] = undelta(params[:content])
    if belongs_to_current_user(comment)
      comment.update(content: params[:content])
    end
    redirect '/posts/' + comment.post.slug
  end
  # DELETE: /comments/5/delete
  delete "/comments/:id/delete" do
    comment = Comment.find_by_id(params[:id])
    if belongs_to_current_user(comment)
      comment.destroy
    end
    redirect '/posts/' + comment.post.slug
  end
end
