class Job < ApplicationRecord
  belongs_to :customer
  belongs_to :machine
  belongs_to :user
  belongs_to :contractor

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
end