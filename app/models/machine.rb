# app/models/machine.rb
class Machine < ApplicationRecord
  belongs_to :customer
  has_one :user, through: :customer
  has_many :jobs, dependent: :destroy

  # --- ADD THIS SECTION ---

  # Define the options for our dropdowns
  MACHINE_MAKES = ["Ice-O-Matic", "Hoshizaki", "Manitowoc", "Koolaire", "Other"]
  MACHINE_TYPES = ["Modular", "Undercounter", "Gourmet", "Other"]
  STATUSES = ["Active", "Inactive", "Boneyard", "Sold", "Other"]

  # These are "virtual" attributes, they don't get saved to the database
  # They are used to capture the "Other" value from the form
  attr_accessor :other_machine_make, :other_machine_type, :other_status

  # Before saving, if "Other" was selected, use the value from the "other" text box
  before_save :substitute_other_values
  def age
    return "Not installed" unless install_date.present?
    
    months = (Time.zone.now.year * 12 + Time.zone.now.month) - (install_date.year * 12 + install_date.month)
    years = months / 12
    remaining_months = months % 12
    "#{years} years, #{remaining_months} months"
  end

  # Find the most recently completed job
  def last_completed_job
    jobs.completed.order(completed_date_time: :desc).first
  end

  # Find the next upcoming scheduled job
  def next_scheduled_job
    jobs.scheduled.where("scheduled_date_time >= ?", Time.zone.now).order(scheduled_date_time: :asc).first
  end

  # Get counts for specific job types
  def preventive_maintenance_jobs_count
    jobs.preventive_maintenance.count
  end

  def repair_jobs_count
    jobs.repair.count
  end

  def new_installation_jobs_count
    jobs.new_installation.count
  end

  private

  def substitute_other_values
    self.machine_make = other_machine_make if machine_make == 'Other' && other_machine_make.present?
    self.machine_type = other_machine_type if machine_type == 'Other' && other_machine_type.present?
    self.status = other_status if status == 'Other' && other_status.present?
  end

  # --- END OF ADDED SECTION ---
end