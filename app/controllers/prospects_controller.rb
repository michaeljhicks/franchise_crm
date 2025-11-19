class ProspectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prospect, only: %i[ show edit update destroy convert ]

  # GET /prospects or /prospects.json
  def index

    @prospects = current_user.prospects
  end

  # GET /prospects/1 or /prospects/1.json
  def show
  end

  # GET /prospects/new
  def new
    @prospect = Prospect.new
  end

  # GET /prospects/1/edit
  def edit
  end

  # POST /prospects or /prospects.json
  def create
    @prospect = current_user.prospects.build(prospect_params)

    respond_to do |format|
      if @prospect.save
        format.html { redirect_to @prospect, notice: "Prospect was successfully created." }
        format.json { render :show, status: :created, location: @prospect }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prospects/1 or /prospects/1.json
  def update
    respond_to do |format|
      if @prospect.update(prospect_params)
        format.html { redirect_to @prospect, notice: "Prospect was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @prospect }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1 or /prospects/1.json
  def destroy
    @prospect.destroy!

    respond_to do |format|
      format.html { redirect_to prospects_path, notice: "Prospect was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # app/controllers/prospects_controller.rb

  def convert
    # 1. Prepare the discovery notes (this part is good)
    discovery_notes = <<~NOTES
      --- Lead Discovery Notes ---
      Business Type: #{@prospect.business_type}
      Hours: #{@prospect.hours}
      Ice Usage: #{@prospect.ice_usage}
      Ice Shape Preference: #{@prospect.ice_shape}
      Seating Capacity: #{@prospect.seating_capacity}
      Special Circumstances: #{@prospect.special_circumstances}

      --- Additional Notes ---
      #{@prospect.notes}
    NOTES

    # --- THIS IS THE FIX ---
    # 2. Create a new customer, passing the contact info via `contacts_attributes`.
    @customer = Customer.new(
      business_name: @prospect.business_name,
      street_address: @prospect.business_location,
      notes: discovery_notes,
      user: current_user, # Assign to the current franchisee
      
      # This hash creates the first Contact object associated with the new Customer.
      contacts_attributes: [{
        name: @prospect.contact_name,
        phone: @prospect.phone,
        email: @prospect.email,
        role: "Primary" # Assign a default role
      }]
    )
    # --- END OF FIX ---

    # 3. Try to save the new customer
    if @customer.save
      # 4. If successful, delete the prospect
      @prospect.destroy
      redirect_to @customer, notice: "Prospect was successfully converted to a new customer."
    else
      # 5. If it fails, redirect back with an error
      redirect_to @prospect, alert: "Could not convert prospect: #{@customer.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_prospect
    # Add .includes(:quotes) to pre-load any quotes associated with this prospect
    @prospect = current_user.prospects.includes(:quotes).find(params[:id])
  end

    # Only allow a list of trusted parameters through.
    def prospect_params
      params.expect(prospect: [ :contact_name, :business_name, :business_location, :email, :phone, :notes, :business_type, :hours, :ice_usage, :ice_shape, :seating_capacity, :special_circumstances, :user_id ])
    end
end
