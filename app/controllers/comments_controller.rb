class CommentsController < ApplicationController
  # POST: /comments
  post "/comments/:post_id" do
    post = Post.find_by_id(params[:post_id])
    if post && is_logged_in?
      params[:user_id] = current_user.id
      comment = Comment.create(params)
    end
    redirect "/posts/" + post.slug
  end
  # PATCH: /comments/5
  patch "/comments/:id" do
    redirect "/posts"
  end
  # DELETE: /comments/5/delete
  delete "/comments/:id/delete" do
    redirect "/posts"
  end
end
