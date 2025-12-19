class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers
  def index
    @customer_count = current_user.customers.count
    @customers = current_user.customers.order(:business_name).page(params[:page]).per(20)
    
    # Pre-load contacts to avoid N+1 queries if you list them in the index
    @contacts = Contact.where(customer_id: @customers.pluck(:id))
  end

  # GET /customers/1
  def show
    # 1. Gmail Logic
    # Fetches recent emails if the user has connected their Google account
    @communications = []
    if current_user.google_access_token.present? && current_user.gmail_alias.present?
      contact_emails = @customer.contacts.pluck(:email).compact_blank
      if contact_emails.any?
        service = GmailService.new(current_user)
        # Pass the alias as the second argument
        @communications = service.list_communications(contact_emails, current_user.gmail_alias)
      end
    end

    # 2. Google Maps Logic (Single Pin)
    # Prepares the data for the map controller if coordinates exist
    if @customer.latitude.present? && @customer.longitude.present?
      @map_marker = [{
        lat: @customer.latitude,
        lng: @customer.longitude,
        title: @customer.business_name,
        info_window_html: "<strong>#{@customer.business_name}</strong><br>#{@customer.full_address}"
      }]
    else
      @map_marker = []
    end
  end

  # GET /customers/new
  def new
    @customer = current_user.customers.build
    # Build 3 empty contact fields by default for the form
    3.times { @customer.contacts.build }
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  def create
    @customer = current_user.customers.build(customer_params)

    if @customer.save
      redirect_to @customer, notice: "Customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url, notice: "Customer was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = current_user.customers.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(
        :business_name, 
        :street_address, 
        :city, 
        :state, 
        :zip, 
        :customer_since, 
        :status, 
        :notes,
        contacts_attributes: [:id, :name, :role, :phone, :email, :_destroy]
      )
    end
end