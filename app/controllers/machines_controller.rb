# app/controllers/machines_controller.rb

class MachinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, except: [:index]
  before_action :set_machine, only: %i[ show edit update destroy ]

  # GET /customers/:customer_id/machines
  def index
    if params[:customer_id]
      # Handle the nested case: /customers/1/machines
      @customer = current_user.customers.find(params[:customer_id])
      @machines = @customer.machines.includes(:customer) # Eager load for consistency
    else
      # Handle the top-level case: /machines
      @machines = current_user.machines.includes(:customer)
    end

    # --- Search Logic ---
    if params[:query].present?
      search_term = "%#{params[:query]}%"
      # NOTE: We add .joins(:customer) here. This is the key change.
      @machines = @machines.joins(:customer).where(
        "machines.machine_make ILIKE ? OR machines.machine_model ILIKE ? OR machines.machine_serial_number ILIKE ? OR customers.business_name ILIKE ?",
        search_term, search_term, search_term, search_term
      )
    end

    # --- Paginate and Order ---
    # To order by `customers.business_name`, we MUST have joined the table.
    # We add `.joins(:customer)` to ensure this is always the case before ordering.
    final_scope = @machines.joins(:customer).order("customers.business_name ASC, machines.created_at DESC")
    @pagy, @machines = pagy(final_scope, items: 20)
  end

  # GET /customers/:customer_id/machines/:id
  def show
  end

  # GET /customers/:customer_id/machines/new
  def new
    @machine = @customer.machines.build
  end

  # GET /customers/:customer_id/machines/:id/edit
  def edit
  end

  # POST /customers/:customer_id/machines
  def create
    @machine = @customer.machines.build(machine_params)

    if @machine.save
      redirect_to customer_machine_url(@customer, @machine), notice: "Machine was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/:customer_id/machines/:id
  def update
    if @machine.update(machine_params)
      redirect_to customer_machine_url(@customer, @machine), notice: "Machine was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /customers/:customer_id/machines/:id
  def destroy
    @machine.destroy!
    redirect_to customer_machines_url(@customer), notice: "Machine was successfully destroyed."
  end

  private
    # This method finds the parent Customer, ensuring it belongs to the current_user
    def set_customer
      @customer = current_user.customers.find(params[:customer_id])
    end

    # This method finds the Machine, ensuring it belongs to the @customer we just found
    def set_machine
      @machine = @customer.machines.includes(:jobs).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
  def machine_params
    params.require(:machine).permit(
      :machine_make, :machine_model, :machine_serial_number,
      :machine_type, :bin_make, :bin_model, :bin_serial_number,
      :purchase_date, :install_date, :status,
      # ADD THESE VIRTUAL ATTRIBUTES
      :other_machine_make, :other_machine_type, :other_status
    )
  end
end