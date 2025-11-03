class ContractorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contractor, only: %i[ show edit update destroy ]

  # GET /contractors
  def index
    # CHANGE: Only show contractors belonging to the current user
    @pagy, @contractors = pagy(current_user.contractors.order(:name), items: 12)
  end

  # GET /contractors/1
  def show
    # Job history logic needs to be updated for admins
    all_jobs = @contractor.jobs

    if current_user.admin?
      @jobs_for_contractor = all_jobs
    else
      @jobs_for_contractor = all_jobs.where(user: current_user)
    end
  end

  # GET /contractors/new
  def new
    # CHANGE: Build the contractor through the current user
    @contractor = current_user.contractors.build
  end

  # GET /contractors/1/edit
  def edit
  end

  # POST /contractors
  def create
    # CHANGE: Build the contractor through the current user
    @contractor = current_user.contractors.build(contractor_params)

    if @contractor.save
      redirect_to contractor_url(@contractor), notice: "Contractor was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contractors/1
  def update
    if @contractor.update(contractor_params)
      redirect_to contractor_url(@contractor), notice: "Contractor was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /contractors/1
  def destroy
    @contractor.destroy!
    redirect_to contractors_url, notice: "Contractor was successfully destroyed."
  end

  private
    def set_contractor
      # CHANGE: Find the contractor securely through the current user's contractors
      @contractor = current_user.contractors.find(params[:id])
    end

    def contractor_params
      params.require(:contractor).permit(:name, :phone_number)
    end
end