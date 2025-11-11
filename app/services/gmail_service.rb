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

  def get_message_metadata(message_id)
    # This method contains the logic that was in the controller
    @service.get_user_message('me', message_id, format: 'metadata', metadata_headers: ['Subject', 'Date'])
  end

  def get_message_body(message_id)
    full_message = @service.get_user_message('me', message_id, format: 'full')
    return "Could not retrieve email." unless full_message&.payload

    plain_text_part = find_plain_text_part(full_message.payload)
    return "No plain text content found." unless plain_text_part&.body

    body = plain_text_part.body
    encoded_data = nil

    # --- THIS IS THE NEW LOGIC ---
    if body.data.present?
      # Case 1: The data is small and was sent inline.
      encoded_data = body.data
    elsif body.attachment_id.present?
      # Case 2: The data is large and we need to make a second API call.
      puts "  [GmailService] - Body data is an attachment, fetching it now..."
      attachment = @service.get_user_message_attachment('me', message_id, body.attachment_id)
      encoded_data = attachment.data if attachment
    end
    # --- END OF NEW LOGIC ---
    
    return "No content in email body." if encoded_data.blank?

    decoded_body = ""
    begin
      decoded_body = Base64.urlsafe_decode64(encoded_data)
    rescue ArgumentError
      puts "  [GmailService] - Rescuing ArgumentError: Body data was not valid Base64. Using as plain text."
      decoded_body = encoded_data
    end
    
    decoded_body.force_encoding('UTF-8').lines.first(15).join.strip
  end

  private

  def find_plain_text_part(payload)
    # Base case: If this part itself is the plain text, we've found it.
    if payload.mime_type == 'text/plain' && payload.body.present?
      return payload
    end
    
    # Recursive step: If this part has sub-parts, search within them.
    if payload.parts.present?
      payload.parts.each do |part|
        # Call this same method on the sub-part
        found_part = find_plain_text_part(part)
        # If the recursive call finds the part, return it immediately.
        return found_part if found_part.present?
      end
    end
    
    # If we've searched all parts and found nothing, return nil.
    nil
  end


end