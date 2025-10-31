# app/controllers/machines_controller.rb

class MachinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, except: [:index, :boneyard]
  before_action :set_machine, only: %i[ show edit update destroy ]

  def index
    # --- Step 1: Establish the base scope for all queries ---
    # This is all machines belonging to the current user.
    base_scope = current_user.machines

    # --- Step 2: Perform the status counts on the UNFILTERED base scope ---
    # This is the new block you are adding. It runs before any search logic.
    status_counts = base_scope.group(:status).count
    @active_machines_count = status_counts["Active"] || 0
    @inactive_machines_count = status_counts["Inactive"] || 0
    @boneyard_machines_count = status_counts["Boneyard"] || 0
    # --- End of new block ---

    # --- Step 3: Determine if we're in a nested or top-level context ---
    if params[:customer_id]
      # Handle the nested case: /customers/1/machines
      @customer = current_user.customers.find(params[:customer_id])
      @machines = @customer.machines.includes(:customer) # Start with just this customer's machines
    else
      # Handle the top-level case: /machines
      @machines = base_scope.includes(:customer) # Start with all machines
    end

    if params[:status].present? && Machine::STATUSES.include?(params[:status])
      # Filter the machines where the status matches the parameter from the URL
      @machines = @machines.where(status: params[:status])
    end

    # --- Step 4: Apply Search Logic (if any) ---
    if params[:query].present?
      search_term = "%#{params[:query]}%"
      @machines = @machines.joins(:customer).where(
        "machines.machine_make ILIKE ? OR machines.machine_model ILIKE ? OR machines.machine_serial_number ILIKE ? OR customers.business_name ILIKE ?",
        search_term, search_term, search_term, search_term
      )
    end

    # --- Step 5: Paginate and Order the final, possibly filtered, results ---
    final_scope = @machines.joins(:customer).order("customers.business_name ASC, machines.created_at DESC")
    @pagy, @machines = pagy(final_scope, items: 20)
  end

  def boneyard
    boneyard_machines = current_user.machines
                                    .includes(:customer)
                                    .where(status: "Boneyard")

    # Paginate the results, just like on our other index pages
    @pagy, @machines = pagy(boneyard_machines.order("customers.business_name ASC"), items: 20)
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
      :other_machine_make, :other_machine_type, :other_status,
      :warranty_registered, :lease_rate
    )
  end
end