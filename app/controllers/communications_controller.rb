class CommunicationsController < ApplicationController
  before_action :authenticate_user!

  def show
    gmail_service = GmailService.new(current_user)
    @message = gmail_service.get_message_metadata(params[:id])
    @body_snippet = gmail_service.get_message_body(params[:id])
  end

end