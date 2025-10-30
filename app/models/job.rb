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
    "Recurring Payment Cancelled", "QuickBooks Account Marked Closed/Inactive",
    "Service Team Notified", "Account Sent to Collections", "Inactive Equipment List Updated", "NOTES"
  ].freeze

  ACCOUNT_ONBOARDING_TASKS = [
    "Lease Signed", "Icebox Customer Profile Created", "Billing Setup in QuickBooks Online",
    "Downpayment Processed in Quickbooks Online", "Equipment Ordered Through IFG",
    "Install Scheduled", "Warranty Registered", "IFG Invoice Paid", "Customer Info Packet Sent", "NOTES"
  ].freeze

   # Use a callback to run this method after a new job is created
  after_create :create_checklist_tasks

  private

  def create_checklist_tasks
    tasks_to_create = case job_type.to_sym
                      when :account_closure
                        ACCOUNT_CLOSURE_TASKS
                      when :account_onboarding
                        ACCOUNT_ONBOARDING_TASKS
                      else
                        [] # No tasks for other job types yet
                      end

    tasks_to_create.each do |task_description|
      self.tasks.create!(description: task_description)
    end
  end
end