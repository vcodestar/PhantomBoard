class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
  
    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("comments-#{@post.id}",
                                partial: "comments/comment",
                                locals: { comment: @comment, post: @post }),
  
            turbo_stream.replace("comment-count-#{@post.id}",
                                 partial: "comments/comment_count",
                                 locals: { post: @post })
          ]
        end
        format.html { redirect_to @post, notice: 'Comment was successfully posted.' }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
  
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
  
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            # Remove the comment from the DOM
            turbo_stream.remove("comment-#{@comment.id}"),
            
            # Replace the comment count with updated content
            turbo_stream.replace("comment-count-#{@post.id}",
                                 partial: "comments/comment_count",
                                 locals: { post: @post })
          ]
        end
        format.html { redirect_to @post, notice: "Comment was successfully deleted." }
      end
    else
      redirect_to @post, alert: "You are not authorized to delete this comment." and return
    end
  end  

  def report
    @comment = Comment.find(params[:id])
  
    if @comment
      @comment.update(reported: true)  # Set the reported status to true
      @comment.user.increment!(:flags)  # Optionally increment the flag count for the user
  
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comment-#{@comment.id}", locals: { comment: @comment })
        end
        format.html { redirect_back(fallback_location: root_path, notice: "User reported successfully.") }
      end
    else
      flash[:alert] = "Could not report the comment."
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
