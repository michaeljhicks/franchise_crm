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

    @this_months_jobs = current_user.jobs
                                    .where(scheduled_date_time: this_month_range)
                                    .order(:scheduled_date_time)
    
    # Find only the uncompleted jobs for this month (for the sub-card)
    # We find jobs that are NOT 'completed' or 'cancelled'.
    @uncompleted_jobs_this_month = @this_months_jobs
                                      .where.not(status: [:completed, :cancelled])


    @next_months_jobs = current_user.jobs
                                    .where(scheduled_date_time: next_month_range)
                                    .order(:scheduled_date_time)
                                    

    @month_after_next_jobs = current_user.jobs
                                          .where(scheduled_date_time: month_after_next_range)
                                          .order(:scheduled_date_time)

    # --- Map Data Logic ---
    # 1. Fetch customers that belong to this user AND have valid coordinates
    customers_with_locations = current_user.customers.where.not(latitude: nil)

    # 2. Build the JSON structure for the map
    @map_markers = customers_with_locations.map do |customer|
      {
        lat: customer.latitude,
        lng: customer.longitude,
        title: customer.business_name,
        # HTML for the popup bubble when you click a pin
        info_window_html: "
          <strong>#{customer.business_name}</strong><br>
          #{customer.city}, #{customer.state}<br>
          <a href='/customers/#{customer.id}'>View Customer</a>
        "
      }
    end                                      
  end
end