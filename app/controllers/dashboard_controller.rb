class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # --- Get the start and end dates for our ranges ---
    today = Time.zone.now
    
    # This Month: From the beginning of the current month to the end of the current month.
    this_month_range = today.beginning_of_month..today.end_of_month

    # Next Month: From the beginning of next month to the end of next month.
    next_month_range = (today + 1.month).beginning_of_month..(today + 1.month).end_of_month

    # The Month After: From the beginning of the month two months from now to its end.
    month_after_next_range = (today + 2.months).beginning_of_month..(today + 2.months).end_of_month


    # --- Query for the jobs in each range ---
    # Find all jobs scheduled for this month, ordered by date
    @this_months_jobs = current_user.jobs
                                    .where(scheduled_date_time: this_month_range)
                                    .order(:scheduled_date_time)
    
    # Find only the uncompleted jobs for this month (for the sub-card)
    # We find jobs that are NOT 'completed' or 'cancelled'.
    @uncompleted_jobs_this_month = @this_months_jobs
                                      .where.not(status: [:completed, :cancelled])

    # Find all jobs scheduled for next month
    @next_months_jobs = current_user.jobs
                                    .where(scheduled_date_time: next_month_range)
                                    .order(:scheduled_date_time)
                                    
    # Find all jobs for the month after next
    @month_after_next_jobs = current_user.jobs
                                          .where(scheduled_date_time: month_after_next_range)
                                          .order(:scheduled_date_time)
  end
end