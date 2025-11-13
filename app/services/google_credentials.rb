# app/services/google_credentials.rb
require 'googleauth'

class GoogleCredentials
  def initialize(user)
    @user = user
  end

  def credentials
    # Build the credentials object for the API client
    creds = Google::Auth::UserRefreshCredentials.new(
      client_id: Rails.application.credentials.dig(:google_oauth2, :client_id),
      client_secret: Rails.application.credentials.dig(:google_oauth2, :client_secret),
      scope: 'email profile https://www.googleapis.com/auth/calendar.events, https://mail.google.com/, https://www.googleapis.com/auth/documents, https://www.googleapis.com/auth/drive',
      access_token: @user.google_access_token,
      refresh_token: @user.google_refresh_token,
      expires_at: @user.google_token_expires_at
    )
    
    # This is the magic. We attach a block that will be called *after* the
    # token is successfully refreshed.
    creds.on_refresh do |new_creds|
      persist_refreshed_tokens(new_creds)
    end
    
    creds
  end

  private

  # This method is responsible for saving the new token info to our database
  def persist_refreshed_tokens(new_creds)
    puts "Google token refreshed. Saving new credentials for User #{@user.id}"
    @user.update!(
      google_access_token: new_creds.access_token,
      google_refresh_token: new_creds.refresh_token,
      google_token_expires_at: new_creds.expires_at
    )
  end
end