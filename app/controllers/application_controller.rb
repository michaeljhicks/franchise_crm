class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  # Run this extra configuration only when we are on a Devise page (like login or sign up)
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # This method tells Devise which extra fields to accept
  def configure_permitted_parameters
    # Fields allowed during sign up (registration)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:owner_name, :franchise_location, :franchise_phone])

    # Fields allowed when editing your profile (account update)
    # We permit ALL the custom fields here.
    devise_parameter_sanitizer.permit(:account_update, keys: [:owner_name, :franchise_location, :franchise_phone, :address, :city, :state, :zip_code])
  end
end