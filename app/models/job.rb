class Job < ApplicationRecord
  belongs_to :customer
  belongs_to :machine
  belongs_to :user
  belongs_to :contractor

  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks

  enum :job_type, {
    account_onboarding: 0,
    new_installation: 1,
    preventive_maintenance: 2,
    repair: 3,
    account_closure: 4
  }

  enum :status, {
    scheduled: 0,
    on_hold: 1,
    completed: 2,
    cancelled: 3
  }

  validates :completed_date_time, presence: true, if: :completed?

  ACCOUNT_CLOSURE_TASKS = [
    "Recurring Payment Cancelled", "QuickBooks Account Marked Closed/Inactive", "Service Team Notified",
    "Account Sent to Collections", "Inactive Equipment List Updated"
  ].freeze

  ACCOUNT_ONBOARDING_TASKS = [
    "Lease Signed", "Icebox Customer Profile Created", "Billing Setup in QuickBooks Online",
    "Downpayment Processed in Quickbooks Online", "Equipment Ordered Through IFG", "Install Scheduled",
    "Warranty Registered", "IFG Invoice Paid", "Customer Info Packet Sent"
  ].freeze

  DEMO_TASKS = [
    "Disconnect and Remove all Iceworks Equipment from Premises",
    "Ensure All Water and Electrical Provisions Are Turned Off",
    "Confirm the Vacant Equipment Space is left Clean and Orderly"
  ].freeze

  NEW_INSTALLATION_TASKS = [
    "Confirm adequate space, power and drain provisions are available",
    "Ensure all water lines are secured and free of leaks",
    "Ensure all drain lines are secured and free of leaks, with proper air gap at terminal drain",
    "Level unit", "Ensure proper operation, monitor first production cycle and adjust ice thickness as needed"
  ].freeze

  PREVENTIVE_MAINTENANCE_TASKS = [
    "Run system through automatic cleaning cycle", "Clean/sanitize evaporator plate(s)",
    "Disassemble and clean all water distribution components", "Clean air filter (if applicable)",
    "Check/clean condensing unit", "Clean/sanitize ice storage bin (if applicable)",
    "Check/change water filter cartridges (if applicable)", "Check/change UV sanitation system bulb (if applicable)",
    "Return unit to service, confirm proper operation and monitor first production cycle"
  ].freeze

  REPAIR_TASKS = [
    "Check/Confirm water pressure to the machine", "Check/confirm voltage to the machine",
    "Verify condenser has adequate flow",
    "Diagnose equipment, correct deficiencies, return unit to service and confirm proper operation"
  ].freeze

  # Define a master hash that maps job types to their task lists
  TASK_TEMPLATES = {
    account_closure: ACCOUNT_CLOSURE_TASKS,
    account_onboarding: ACCOUNT_ONBOARDING_TASKS,
    new_installation: NEW_INSTALLATION_TASKS,
    preventive_maintenance: PREVENTIVE_MAINTENANCE_TASKS,
    repair: REPAIR_TASKS
    # No entry for :demo yet since it's not in our enum, we'll add it later if needed.
  }.freeze

  after_create :create_checklist_tasks

  after_update :send_completion_notification, if: :completed_status_changed?


  private

  def create_checklist_tasks
    # Use our new TASK_TEMPLATES hash for a cleaner lookup
    tasks_to_create = TASK_TEMPLATES[job_type.to_sym] || []

    tasks_to_create.each do |task_description|
      # Use `create!` to ensure if one fails, the whole process stops.
      self.tasks.create!(description: task_description)
    end
  end

  def completed_status_changed?
    # This checks two things:
    # 1. Did the `status` attribute just change in this update?
    # 2. Is the new `status` value 'completed'?
    saved_change_to_status? && status == 'completed'
  end

  def send_completion_notification
    # Use `deliver_later` to send the email in a background job for better performance
    JobMailer.job_completed_notification(self).deliver_later
  end
end