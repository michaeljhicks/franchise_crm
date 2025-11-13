class CustomersController < ApplicationController
  before_action :authenticate_user! # ADD THIS LINE
  before_action :set_customer, only: %i[ show edit update destroy ]

  def index
    # Start with the base scope and eager-load contacts for display
    customers = current_user.customers.includes(:contacts)

    @total_customers = customers.count

    if params[:query].present?
      search_term = "%#{params[:query]}%"
      # We use `distinct` to prevent duplicate customer results if a customer has multiple contacts that match.
      customers = customers.left_joins(:contacts).distinct.where(
        "customers.business_name ILIKE ? OR contacts.name ILIKE ? OR customers.city ILIKE ?",
        search_term, search_term, search_term
      )
    end

    # The pagy call remains the same
    @pagy, @customers = pagy(customers.order(:business_name), items: 20)
  end

  # app/controllers/customers_controller.rb

  def show
    # 1. Initialize @communications to a default empty array.
    @communications = []
    
    # 2. Only proceed if the user is connected to Google.
    if current_user.google_access_token.present?
      
      # 3. Pluck all the valid email addresses from the customer's contacts.
      contact_emails = @customer.contacts.pluck(:email).compact_blank

      # 4. Only call the Gmail service if we actually have emails to search for.
      if contact_emails.any?
        
        # 5. Initialize the service and get the communications for this customer.
        service = GmailService.new(current_user)
        @communications = service.list_communications(contact_emails)
      end
    end

    # The @customer is already found by the set_customer before_action.
    # The view will now receive either the found emails or an empty array.
  end

  # app/controllers/customers_controller.rb
  def new
    @customer = current_user.customers.build
    # ADD THIS LINE to build the 3 blank contact fields
    3.times { @customer.contacts.build }
  end

  # GET /customers/1/edit
  def edit
    # This ensures there are always 3 contact fields on the edit form.
    (3 - @customer.contacts.size).times { @customer.contacts.build }
  end

  # POST /customers or /customers.json
  def create
    @customer = current_user.customers.build(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: "Customer was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy!

    respond_to do |format|
      format.html { redirect_to customers_path, notice: "Customer was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = current_user.customers.includes(:machines, :jobs).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(
      # Top-level customer attributes
      :business_name, :street_address, :city, :state, :zip,
      :customer_since, :status, :notes,

      # --- THIS IS THE CRITICAL PART ---
      # This tells Rails to accept a hash of attributes for contacts.
      # For each contact, we permit the ID (for existing records),
      # all its attributes, and the special _destroy flag for deletion.
      contacts_attributes: [:id, :name, :role, :phone, :email, :_destroy]
      )
    end

end
