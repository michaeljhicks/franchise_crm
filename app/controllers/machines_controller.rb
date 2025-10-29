# app/controllers/machines_controller.rb

class MachinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, except: [:index]
  before_action :set_machine, only: %i[ show edit update destroy ]

  # GET /customers/:customer_id/machines
  def index
    if params[:customer_id]
      # This is the nested route: /customers/1/machines
      @customer = current_user.customers.find(params[:customer_id])
      @machines = @customer.machines
    else
      # This is the new top-level route: /machines
      @machines = current_user.machines
    end
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
      @machine = @customer.machines.find(params[:id])
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