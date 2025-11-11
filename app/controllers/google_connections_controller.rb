# app/controllers/google_connections_controller.rb
class GoogleConnectionsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    # Find the current user and clear all Google-related columns
    current_user.update(
      provider: nil,
      uid: nil,
      google_access_token: nil,
      google_refresh_token: nil
    )

    # Redirect back to the profile page with a success message
    redirect_to edit_user_registration_path, notice: "Successfully disconnected from your Google account."
  end
end