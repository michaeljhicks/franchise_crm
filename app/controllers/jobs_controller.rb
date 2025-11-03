class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer_and_machine_for_nesting, only: [:new, :create]
  before_action :set_nested_job, only: [:edit, :update, :destroy]
  before_action :set_job_for_completion, only: [:complete, :reschedule]

  def index
    @jobs = current_user.jobs.includes(:customer, :machine)

    # Note: I'm simplifying this logic. The old nested route for a machine's jobs is less important
    # than the main /jobs index. We can add it back if needed, but this is cleaner.

    if params[:status].present?
      @jobs = @jobs.where(status: params[:status])
    end

    if params[:job_type].present?
      @jobs = @jobs.where(job_type: params[:job_type])
    end

    if params[:query].present?
      @jobs = @jobs.joins(:customer).where("customers.business_name ILIKE ?", "%#{params[:query]}%")
    end

    @pagy, @jobs = pagy(@jobs.order(scheduled_date_time: :desc), items: 25)
  end

  def show
    if current_user.admin?
      @job = Job.includes(:customer, :machine, :tasks).find(params[:id])
    else
      @job = current_user.jobs.includes(:customer, :machine, :tasks).find(params[:id])
    end
    
    # These are needed for the view's nested links
    @customer = @job.customer
    @machine = @job.machine
  end

  def new
    # @machine is now set correctly by `set_customer_and_machine_for_nesting`
    @job = @machine.jobs.build
    @contractors = current_user.contractors.order(:name)
  end

  def edit
    # @job, @customer, and @machine are now set correctly by `set_nested_job`
    @contractors = current_user.contractors.order(:name)
  end

  def create
    # @machine and @customer are from the before_action
    @job = @machine.jobs.build(job_params)
    @job.customer = @customer
    @job.user = current_user

    if @job.save
      redirect_to [@customer, @machine, @job], notice: "Job was successfully created."
    else
      @contractors = current_user.contractors.order(:name) # Need to reload for the form
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # @job is from the before_action
    if @job.update(job_params)
      redirect_to @job, notice: "Job was successfully updated."
    else
      @contractors = current_user.contractors.order(:name) # Need to reload for the form
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @job and its parents are from the before_action
    @job.destroy!
    redirect_to jobs_url, notice: "Job was successfully destroyed."
  end

  def complete
    # @job is from the before_action
    if @job.update(status: :completed, completed_date_time: Time.current)
      redirect_to reschedule_job_path(@job), notice: "Job successfully marked as completed."
    else
      redirect_to @job, alert: "Could not mark job as completed."
    end
  end

  def reschedule
  end

  private

  # --- New, Explicit Private Methods ---
  
  # Finds the parent customer and machine for creating NEW jobs.
  def set_customer_and_machine_for_nesting
    @customer = current_user.customers.find(params[:customer_id])
    @machine = @customer.machines.find(params[:machine_id])
  end

  # Finds an EXISTING job, and its parents, securely. Used for edit/update/destroy.
  def set_nested_job
    @customer = current_user.customers.find(params[:customer_id])
    @machine = @customer.machines.find(params[:machine_id])
    @job = @machine.jobs.find(params[:id])
  end

  # Finds an existing job by its ID, scoped to the current user. Used for `complete`.
  def set_job_for_completion
    @job = current_user.jobs.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :scheduled_date_time, :completed_date_time, :job_type, :status,
      :contractor_notes, :internal_notes, :contractor_id,
      tasks_attributes: [:id, :completed]
    )
  end
end