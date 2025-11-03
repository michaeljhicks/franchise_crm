# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pagy::Backend

  layout :layout_by_resource

  around_action :set_time_zone, if: :current_user

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # ... your devise sanitizer code ...
    devise_parameter_sanitizer.permit(:sign_up, keys: [:owner_name, :franchise_location, :franchise_phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:owner_name, :franchise_location, :franchise_phone, :address, :city, :state, :zip_code, :time_zone])
  end

  private

  def layout_by_resource
    # If a user is signed in, use the main dashboard layout.
    # Otherwise (for login, signup, etc.), use the simple application layout.
    if user_signed_in?
      "dashboard"
    else
      "application"
    end
  end

  def set_time_zone(&block)
    # Time.use_zone is a special Rails method that temporarily sets the time zone for the duration of the block
    Time.use_zone(current_user.time_zone, &block)
  end
end