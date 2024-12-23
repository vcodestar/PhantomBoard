class Admin::DashboardController < ApplicationController
    before_action :authenticate_user!  # Ensure user is logged in
    before_action :verify_admin        # Ensure user is an admin
  
    def index
      # Admin dashboard logic
    end
  
    private
  
    def verify_admin
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user&.admin?
    end
  end
  