class Admin::DashboardController < Admin::BaseController
  def index
    # Fetch the total count for each model. These will be available in the view.
    @user_count = User.count
    @customer_count = Customer.count
    @machine_count = Machine.count
    @job_count = Job.count
  end
end