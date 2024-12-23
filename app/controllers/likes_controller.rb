class LikesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @post = Post.find(params[:post_id])
      @like = @post.likes.build(user: current_user)
  
      if @like.save
        respond_to do |format|
          format.html { redirect_to posts_path, notice: 'Liked post.' }
          format.js # For AJAX support
        end
      else
        respond_to do |format|
          format.html { redirect_to posts_path, alert: 'Unable to like post.' }
          format.js
        end
      end
    end
  
    def destroy
      @post = Post.find(params[:post_id])
      @like = @post.likes.find_by(user: current_user)
  
      if @like&.destroy
        respond_to do |format|
          format.html { redirect_to posts_path, notice: 'Unliked post.' }
          format.js
        end
      else
        respond_to do |format|
          format.html { redirect_to posts_path, alert: 'Unable to unlike post.' }
          format.js
        end
      end
    end
  end
  