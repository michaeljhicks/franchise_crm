# app/services/gmail_service.rb
require 'google/apis/gmail_v1'
require 'googleauth'

class GmailService
  def initialize(user)
    @user = user
    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = GoogleCredentials.new(user).credentials
  end

  # This method will find recent emails to/from a specific customer
  def list_communications(customer_email, max_results: 5)
    return [] if customer_email.blank?

    # Use Gmail's powerful search query syntax
    query = "from:#{customer_email} OR to:#{customer_email}"

    # Search for messages matching the query
    result = @service.list_user_messages('me', q: query, max_results: max_results)
    
    # If no messages are found, return an empty array
    return [] unless result.messages.present?

    # Fetch the metadata for each message (this is much faster than fetching the full content)
    messages = result.messages.map do |message|
      @service.get_user_message('me', message.id, format: 'metadata', metadata_headers: ['Subject', 'Date'])
    end

    messages
  end

end