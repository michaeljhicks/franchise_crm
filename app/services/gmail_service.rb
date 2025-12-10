# app/services/gmail_service.rb
require 'google/apis/gmail_v1'
require 'googleauth'

class GmailService
  def initialize(user)
    @user = user
    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = GoogleCredentials.new(user).credentials
  end

  def list_communications(customer_emails, user_alias, max_results: 5)
    return [] if customer_emails.blank? || user_alias.blank?

    # Build a highly specific query:
    # "((from:user@alias.com to:contact@a.com) OR (from:contact@a.com to:user@alias.com)) OR ((from:user@alias.com to:contact@b.com) OR (from:contact@b.com to:user@alias.com))"
    query_parts = customer_emails.map do |customer_email|
      "((from:#{user_alias} to:#{customer_email}) OR (from:#{customer_email} to:#{user_alias}))"
    end
    query = query_parts.join(' OR ')

    puts "  [GmailService] - Searching with query: #{query}"


    begin
      result = @service.list_user_messages('me', q: query, max_results: max_results)
      
      return [] unless result.messages.present?

      messages = result.messages.map do |message|
        @service.get_user_message('me', message.id, format: 'metadata', metadata_headers: ['Subject', 'Date'])
      end
      return messages
    rescue Google::Apis::ClientError => e
      puts "Error listing Gmail messages: #{e.message}"
      return [] # Return an empty array on error
    end
  end

  def get_message_metadata(message_id)
    # This method contains the logic that was in the controller
    @service.get_user_message('me', message_id, format: 'metadata', metadata_headers: ['Subject', 'Date'])
  end

  # app/services/gmail_service.rb

  def get_message_body(message_id)
    # 1. Fetch the full message from Gmail
    message = @service.get_user_message(
      'me',
      message_id,
      format: 'full'
    )

    payload = message.payload

    # 2. Find the text/plain part (or fall back to the first part / payload)
    part =
      if payload.parts&.any?
        payload.parts.find { |p| p.mime_type == 'text/plain' } || payload.parts.first
      else
        payload
      end

    data = part.body&.data.to_s

    # 3. Decode base64 if it *is* base64, otherwise use as-is
    decoded_body =
      begin
        Base64.urlsafe_decode64(data)
      rescue ArgumentError
        Rails.logger.info "[GmailService] - Rescuing ArgumentError: Body data was not valid Base64. Using as plain text."
        data
      end

    # 4. Make the string safely UTF-8 (no more invalid byte sequence errors)
    safe = decoded_body.dup
    safe.force_encoding(Encoding::ASCII_8BIT) # treat as raw bytes first
    safe = safe.encode(
      Encoding::UTF_8,
      invalid: :replace,
      undef:   :replace,
      replace: "�"  # or "" if you prefer to drop bad bytes
    )

    # 5. Return a short preview (first 15 lines)
    safe.lines.first(15).join.strip
  end


  def send_email(to:, from:, subject:, body:)
    raise ArgumentError, "Recipient (To) address cannot be blank."  if to.to_s.strip.blank?
    raise ArgumentError, "Sender (From) address cannot be blank."    if from.to_s.strip.blank?

    # 1. Build RFC 2822 email with Mail gem
    message = Mail.new do
      to      to.to_s.strip
      from    from.to_s.strip
      subject subject.to_s

      text_part do
        body body.to_s
      end
    end

    # 2. Get raw RFC 2822 content (Mail.encoded already uses CRLF)
    raw_content = message.encoded

    # (Optional: normalize line endings if you want to be extra sure)
    # raw_content = raw_content.gsub(/\r?\n/, "\r\n")

    puts "--- DEBUG: RFC 2822 Email Content (sent to Gmail::Message#raw) ---"
    puts raw_content
    puts "-----------------------------------------------------------------"

    # 3. IMPORTANT: DO **NOT** base64 encode here.
    #    The google-api-ruby-client will base64url-encode `raw` automatically.
    gmail_message = Google::Apis::GmailV1::Message.new(raw: raw_content)

    # 4. Send via Gmail API
    @service.send_user_message('me', gmail_message)

    nil
  rescue => e
    puts "[GmailService] API ERROR: #{e.class}: #{e.message}"
    return e
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