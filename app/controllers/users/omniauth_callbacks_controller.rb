# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # CHANGE THIS LINE:
  # Skip the CSRF token check for BOTH the initial passthru and the final callback.
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    auth = request.env["omniauth.auth"]
    if current_user.present?
      current_user.update(
        provider: auth.provider,
        uid: auth.uid,
        google_access_token: auth.credentials.token,
        google_refresh_token: auth.credentials.refresh_token,
        google_token_expires_at: Time.at(auth.credentials.expires_at)
      )
      redirect_to edit_user_registration_path, notice: "Successfully connected to Google Calendar."
    else
      redirect_to new_user_session_path, alert: "Please sign in to connect your Google account."
    end
  end

  # We can optionally add an empty passthru method to be explicit, but it's not always required.
  # def passthru
  #   super
  # end
end