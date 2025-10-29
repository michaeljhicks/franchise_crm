# app/controllers/admin/base_controller.rb

# Note the module declaration: Admin:: which matches our folder structure
class Admin::BaseController < ApplicationController
  # This sets the overall layout for all admin pages, if you choose to create one
  # layout 'admin' 

  # Run this method before any action in any controller that inherits from this one
  before_action :require_admin!

  private

  # This is our security gatekeeper method
  def require_admin!
    # First, make sure a user is logged in at all
    authenticate_user!

    # Then, check if the logged-in user has the admin flag set to true
    unless current_user.admin?
      # If not, send them to the home page with an alert message
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end
end