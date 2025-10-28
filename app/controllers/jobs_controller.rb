# app/controllers/jobs_controller.rb
class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer_and_machine # Find the parent objects first
  before_action :set_job, only: %i[ show edit update destroy ]

  def index
    @jobs = @machine.jobs
  end

  def show
  end

  def new
    @job = @machine.jobs.build
  end

  def edit
  end

  def create
    @job = @machine.jobs.build(job_params)
    @job.customer = @machine.customer
    @job.user = current_user # Explicitly assign the franchisee (current_user)

    if @job.save
      redirect_to customer_machine_job_url(@customer, @machine, @job), notice: "Job was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      redirect_to customer_machine_job_url(@customer, @machine, @job), notice: "Job was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy!
    redirect_to customer_machine_jobs_url(@customer, @machine), notice: "Job was successfully destroyed."
  end

  private
    def set_customer_and_machine
      @customer = current_user.customers.find(params[:customer_id])
      @machine = @customer.machines.find(params[:machine_id])
    end

    def set_job
      @job = @machine.jobs.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:scheduled_date_time, :completed_date_time, :job_type, :status, :contractor_notes, :internal_notes, :contractor_id)
    end
end