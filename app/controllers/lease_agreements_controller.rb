class LeaseAgreementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lease_agreement, only: %i[ show edit update destroy ]

  def index
    @lease_agreements = current_user.lease_agreements.includes(:customer, :machine)
    @pagy, @lease_agreements = pagy(@lease_agreements.order(lease_start_date: :desc))
  end

  def show
  end

  def new
    @lease_agreement = current_user.lease_agreements.build(
      # Pre-fill from URL parameters if they exist
      customer_id: params[:customer_id],
      machine_id: params[:machine_id]
    )
    @customers = current_user.customers.order(:business_name)
    @machines = current_user.machines.order(:machine_model)
  end

  def edit
    @customers = current_user.customers.order(:business_name)
    @machines = current_user.machines.order(:machine_model)
  end

  def create
    @lease_agreement = current_user.lease_agreements.build(lease_agreement_params)
    if @lease_agreement.save
      redirect_to @lease_agreement, notice: "Lease agreement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lease_agreements/1 or /lease_agreements/1.json
  def update
    respond_to do |format|
      if @lease_agreement.update(lease_agreement_params)
        format.html { redirect_to @lease_agreement, notice: "Lease agreement was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @lease_agreement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lease_agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lease_agreements/1 or /lease_agreements/1.json
  def destroy
    @lease_agreement.destroy!

    respond_to do |format|
      format.html { redirect_to lease_agreements_path, notice: "Lease agreement was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_lease_agreement
      @lease_agreement = current_user.lease_agreements.find(params[:id])
    end

    def lease_agreement_params
      params.require(:lease_agreement).permit(:lease_start_date, :lease_end_date, :lease_rate, :customer_id, :machine_id)
    end
end
