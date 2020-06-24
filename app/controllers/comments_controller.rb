class CommentsController < ApplicationController
  # POST: /comments
  post "/post/:post_id/comments" do
    post = Post.find_by_id(params[:post_id])
    if post && is_logged_in? && !params[:delta].empty?
      current_user.comments.create(params)
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
    if belongs_to_current_user(comment)
      comment.update(delta: params[:delta])
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
