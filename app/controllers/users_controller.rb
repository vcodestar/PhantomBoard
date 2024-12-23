class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure only authenticated users can report
  before_action :authenticate_admin!, only: [:destroy] # Ensure only admins can delete users
  before_action :set_user, only: [:posts]
  
  # Action to report a user
  def report
    @user = User.find(params[:id]) # Find the user being reported
    
    if @user
      @user.increment!(:flags) # Increment the flags count
      flash[:notice] = "User reported successfully."
    else
      flash[:alert] = "Could not report the user."
    end
    
    redirect_back(fallback_location: root_path) # Redirect back to the previous page
  end

  # Action to delete a user (only for admins)
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:notice] = "User deleted successfully."
    else
      flash[:alert] = "Failed to delete user."
    end

    redirect_to admin_dashboard_path  # Redirect back to the admin dashboard or another path
  end

  def posts
    @posts = @user.posts.includes(:comments, :likes).order(created_at: :desc)
  end
  
  private
  
  # Private method to ensure only admins can perform certain actions
  def authenticate_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path  # Or any other path where non-admins should be redirected
    end
  end

  def set_user
    @user = User.find(params[:id])
  end
  
end
