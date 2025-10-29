class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Find jobs belonging to the current user that are scheduled
    # between now and 7 days from now.
    @upcoming_jobs = current_user.jobs
                                  .where(scheduled_date_time: Time.zone.now..7.days.from_now)
                                  .order(scheduled_date_time: :asc)
  end
end