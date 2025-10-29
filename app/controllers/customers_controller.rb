class CustomersController < ApplicationController
  before_action :authenticate_user! # ADD THIS LINE
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers or /customers.json
  def index
    # Start with the base scope of the current user's customers
    customers = current_user.customers

    if params[:query].present?
      # If a search query is present, filter the results
      # The `?` is a placeholder to safely insert the query
      # `ILIKE` is a PostgreSQL feature for case-insensitive searching
      search_term = "%#{params[:query]}%"
      customers = customers.where(
        "business_name ILIKE ? OR main_contact_name ILIKE ? OR city ILIKE ?",
        search_term, search_term, search_term
      )
    end

    # Finally, assign the (possibly filtered) results to the instance variable
    @pagy, @customers = pagy(customers.order(:business_name), items: 20)
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
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
      @customer = Customer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.expect(customer: [ :business_name, :street_address, :city, :state, :zip, :main_contact_name, :main_contact_phone, :main_contact_email, :customer_since, :status, :notes, :user_id ])
    end
end
