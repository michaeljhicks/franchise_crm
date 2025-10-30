class JobMailer < ApplicationMailer
  # Set a default 'from' address
  default from: 'ned@iceworksUS.com'

  def job_completed_notification(job)
    @job = job
    @customer = @job.customer
    # Find all tasks for this job that have been completed
    @completed_tasks = @job.tasks.where.not(completed_at: nil)

    mail(
      to: @customer.main_contact_email,
      subject: "Work Completed for Job: #{@job.job_type.humanize.titleize}"
    )
  end
end