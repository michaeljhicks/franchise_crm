require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class GoogleCalendarService
  
  # The `initialize` method runs when we do `GoogleCalendarService.new(user)`
  # It sets up the connection to the Google API for a specific user.
  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = credentials_for(user)
  end

   def create_event(job)
     # --- THE DEFINITIVE FIX ---
     # Perform a direct lookup in Rails' master list of time zones.
     # ActiveSupport::TimeZone::MAPPING is a hash like:
     # { "Mountain Time (US & Canada)" => "America/Denver", ... }
     iana_time_zone_name = ActiveSupport::TimeZone::MAPPING[@user.time_zone]

     # Add a puts statement for debugging. This will print to your `bin/dev` log.
     puts "Attempting to create Google event for user #{@user.id} with time zone: '#{iana_time_zone_name}' (from user setting '#{@user.time_zone}')"

     # If the lookup fails for any reason, fall back to UTC to prevent crashing.
     iana_time_zone_name ||= "UTC"

     event = Google::Apis::CalendarV3::Event.new(
        summary: "Job: #{job.job_type.humanize.titleize} for #{job.customer.business_name}",
        location: job.customer.street_address,
        description: "Customer: #{job.customer.business_name}\nMachine: #{job.machine.machine_model}\nNotes: #{job.internal_notes}",
        
        start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: job.scheduled_date_time.iso8601,
        time_zone: iana_time_zone_name
        ),
        
        end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: (job.scheduled_date_time + 1.hour).iso8601,
        time_zone: iana_time_zone_name
        )
        )

     @service.insert_event('primary', event)
    end

    # --- ADD THIS METHOD ---
  def update_event(job)
    # Find the existing event on Google Calendar using the stored ID
    event = @service.get_event('primary', job.google_event_id)

    # Update the event's attributes
    event.summary = "Job: #{job.job_type.humanize.titleize} for #{job.customer.business_name}"
    event.location = job.customer.street_address
    event.start.date_time = job.scheduled_date_time.iso8601
    event.end.date_time = (job.scheduled_date_time + 1.hour).iso8601

    @service.update_event('primary', event.id, event)
  rescue Google::Apis::ClientError => e
    puts "Could not find Google Calendar event to update, skipping. (Error: #{e.message})"
  end

  # --- UPDATE THIS METHOD ---
  def delete_event(google_event_id)
    puts "Attempting to delete Google Calendar event: #{google_event_id}"
    @service.delete_event('primary', google_event_id)
  rescue Google::Apis::ClientError => e
    # If the error is "Not Found", it means the event is already deleted.
    if e.message.include?("Not Found") || e.message.include?("Gone")
      puts "Event not found on Google Calendar, already deleted."
    else
      # Re-raise any other errors (like authentication issues)
      raise
    end
  end
  # We can add methods for update_event(job) and delete_event(job) here later.

  private

  # This helper method builds the authorization credentials from the user's saved tokens.
  def credentials_for(user)
    creds = Google::Auth::UserRefreshCredentials.new(
      client_id: Rails.application.credentials.dig(:google_oauth2, :client_id),
      client_secret: Rails.application.credentials.dig(:google_oauth2, :client_secret),
      scope: 'https://www.googleapis.com/auth/calendar.events',
      access_token: user.google_access_token,
      refresh_token: user.google_refresh_token,
      # This is important for handling token expiration
      # expires_at: user.google_token_expires_at 
    )
    # The Google client library can automatically handle refreshing the access token
    # if it has expired, as long as we have the refresh_token.
    # We may need to add a `google_token_expires_at` column to the users table later.
    
    creds
  end
end