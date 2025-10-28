# app/models/machine.rb
class Machine < ApplicationRecord
  belongs_to :customer
  has_one :user, through: :customer
  has_many :jobs, dependent: :destroy

  # --- ADD THIS SECTION ---

  # Define the options for our dropdowns
  MACHINE_MAKES = ["Ice-O-Matic", "Hoshizaki", "Manitowoc", "Koolaire", "Other"]
  MACHINE_TYPES = ["Modular", "Undercounter", "Gourmet", "Other"]
  STATUSES = ["Active", "Inactive", "Sold", "Other"]

  # These are "virtual" attributes, they don't get saved to the database
  # They are used to capture the "Other" value from the form
  attr_accessor :other_machine_make, :other_machine_type, :other_status

  # Before saving, if "Other" was selected, use the value from the "other" text box
  before_save :substitute_other_values

  private

  def substitute_other_values
    self.machine_make = other_machine_make if machine_make == 'Other' && other_machine_make.present?
    self.machine_type = other_machine_type if machine_type == 'Other' && other_machine_type.present?
    self.status = other_status if status == 'Other' && other_status.present?
  end

  # --- END OF ADDED SECTION ---
end