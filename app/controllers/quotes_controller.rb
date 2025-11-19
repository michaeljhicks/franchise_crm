class QuotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quote, only: %i[ show edit update destroy ]
  before_action :resolve_quote_owner, only: [:create]


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
    @quote = current_user.quotes.build
    3.times { @quote.quote_items.build }

    # --- THIS IS THE NEW LOGIC ---
    # Load both collections
    prospects = current_user.prospects.order(:business_name)
    customers = current_user.customers.order(:business_name)

    # Create a grouped array for the dropdown, using our "type_id" hack
    @grouped_options = [
      ['Prospects', prospects.map { |p| [p.business_name, "prospect_#{p.id}"] }],
      ['Customers', customers.map { |c| [c.business_name, "customer_#{c.id}"] }]
    ]
    # --- END OF NEW LOGIC ---
  end

  def edit
    # Also load prospects for the edit form dropdown
    @prospects = current_user.prospects.order(:business_name)
  end

  def create
    # The `resolve_quote_owner` method has already found or created the @prospect
    # and put its ID into the params.
    @quote = @prospect.quotes.build(quote_params)
    @quote.user = current_user

    if @quote.save
      redirect_to @quote, notice: "Quote was successfully created."
    else
      # Reload grouped options on failure
      prospects = current_user.prospects.order(:business_name)
      customers = current_user.customers.order(:business_name)
      @grouped_options = [
        ['Prospects', prospects.map { |p| [p.business_name, "prospect_#{p.id}"] }],
        ['Customers', customers.map { |c| [c.business_name, "customer_#{c.id}"] }]
      ]
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

    def resolve_quote_owner
      identifier = params[:quote].delete(:owner_identifier)
      return if identifier.blank? # Handle blank selection case
      
      owner_type, owner_id = identifier.split('_')
      
      if owner_type == 'customer'
        # If a customer is selected, we need to find or create a prospect with the same name.
        # A quote always belongs to a prospect in our current model.
        customer = current_user.customers.find(owner_id)
        @prospect = current_user.prospects.find_or_create_by!(business_name: customer.business_name) do |prospect|
          # If creating a new prospect from a customer, copy the details
          prospect.business_location = customer.street_address
          prospect.contact_name = customer.contacts.first&.name
          prospect.email = customer.contacts.first&.email
          prospect.phone = customer.contacts.first&.phone
        end
      else # owner_type is 'prospect'
        @prospect = current_user.prospects.find(owner_id)
      end
      
      # Add the final prospect_id back into the params for `quote_params` to use.
      params[:quote][:prospect_id] = @prospect.id
    end
   
    def quote_params
      # Permit `prospect_id` but not the temporary `owner_identifier`
      params.require(:quote).permit(
        :expiration_date, :prospect_id,
        quote_items_attributes: [
          :id, :machine_make, :machine_model, :bin_make, :bin_model,
          :ice_production, :ice_storage, :lease_rate, :_destroy
        ]
      )
    end
end