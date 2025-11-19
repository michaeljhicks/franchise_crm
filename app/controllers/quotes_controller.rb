class QuotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quote, only: %i[ show edit update destroy ]

  def generate_document
    # --- THIS IS THE FIX ---
    # Find the quote here, inside the action, to guarantee it is not nil.
    # We will use the same robust, eager-loading query from the before_action.
    @quote = current_user.quotes.includes(:prospect, :user, :quote_items).find(params[:id])
    
    # The rest of the method is the same
    service = GoogleDocsService.new(current_user)
    new_document_id = service.generate_quote_from_template(@quote)
    
    doc_url = "https://docs.google.com/document/d/#{new_document_id}/edit"
    redirect_to doc_url, allow_other_host: true, notice: "Quote document was successfully generated!"
  end

  def index
    # Scope quotes to the current user and eager-load prospects for performance
    @quotes = current_user.quotes.includes(:prospect)
    # Add pagination for consistency
    @pagy, @quotes = pagy(@quotes.order(created_at: :desc))
  end

  def show
    # @quote is set by the before_action
  end

  def new
    # Build a new quote scoped to the current user, pre-filling the prospect if an ID is passed
    @quote = current_user.quotes.build(prospect_id: params[:prospect_id])
    # Build 3 blank quote items so the form displays 3 sets of fields
    3.times { @quote.quote_items.build }
    # Load the current user's prospects for the dropdown menu
    @prospects = current_user.prospects.order(:business_name)
  end

  def edit
    # Also load prospects for the edit form dropdown
    @prospects = current_user.prospects.order(:business_name)
  end

  def create
    @quote = current_user.quotes.build(quote_params)

    if @quote.save
      redirect_to @quote, notice: "Quote was successfully created."
    else
      # If the save fails, we must reload @prospects for the form to re-render
      @prospects = current_user.prospects.order(:business_name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Quote was successfully updated."
    else
      # If the save fails, we must reload @prospects for the form to re-render
      @prospects = current_user.prospects.order(:business_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy!
    redirect_to quotes_url, notice: "Quote was successfully destroyed."
  end

  private
    def set_quote
      @quote = current_user.quotes.includes(:prospect, :user, :quote_items).find(params[:id])
    end

    # Permit the nested attributes for the quote items
    def quote_params
      params.require(:quote).permit(
        :expiration_date, :prospect_id, 
        quote_items_attributes: [:id, :description, :ice_production, :ice_storage, :lease_rate, :_destroy]
      )
    end
end