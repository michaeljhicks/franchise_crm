# app/controllers/communications_controller.rb
class CommunicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:new, :create]

  def show
    gmail_service = GmailService.new(current_user)
    @message = gmail_service.get_message_metadata(params[:id])
    @body_snippet = gmail_service.get_message_body(params[:id])
  end

  def new
    # @customer is set by before_action :set_customer
    # The @aliases call is no longer needed!
  end

  def create
    error = GmailService.new(current_user).send_email(
      to: params[:to],
      from: params[:from],
      subject: params[:subject],
      body: params[:body]
    )

    respond_to do |format|
      if error
        # CASE: Failure
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "flash-container",
            partial: "layouts/flash",
            locals: { alert: "Error sending email: #{error.message}" }
          ), status: :unprocessable_entity
        end
        
        format.html do
          # Fallback for standard HTML requests: reload page with error
          redirect_to new_communication_path(customer_id: params[:customer_id]), 
                      alert: "Error: #{error.message}"
        end
      else
        # CASE: Success
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("modal"),
            turbo_stream.prepend(
              "flash-container",
              partial: "layouts/flash",
              locals: { notice: "Email sent successfully!" }
            )
          ]
        end

        format.html do
          # Fallback for standard HTML requests: go back to customer page
          redirect_to customer_path(params[:customer_id]), 
                      notice: "Email sent successfully!"
        end
      end
    end
  end
  
  private
  
  def set_customer
    @customer = current_user.customers.find(params[:customer_id])
  end
end
