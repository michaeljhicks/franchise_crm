class Admin::DashboardController < Admin::BaseController
  def index
    # --- Franchisee Data ---
    # Get all users (franchisees) ordered by name for the list.
    @users = User.order(:owner_name)
    @user_count = @users.count # Keep the total count for the header

    # --- Customer Data ---
    # This single query gets the count of customers for each franchisee.
    # It joins the customers table to the users table and groups by the user's name.
    # The result is a hash like: { "James Jones" => 15, "Autumn Blom" => 12 }
    @customers_by_franchisee = Customer.joins(:user).group("users.owner_name").count
    @customer_count = Customer.count # Keep the overall total

    # --- Machine Data ---
    # Same pattern as customers.
    @machines_by_franchisee = Machine.joins(:customer => :user).group("users.owner_name").count
    @machine_count = Machine.count # Keep the overall total

    # --- Jobs Data (Current Month Only) ---
    # This query first filters jobs to the current month, then groups by franchisee.
    @jobs_this_month_by_franchisee = Job.where(scheduled_date_time: Time.zone.now.all_month)
                                        .joins(:user).group("users.owner_name").count
    @job_count = Job.count # Keep the overall total for context if you wish
  end
end