class Task < ApplicationRecord
  belongs_to :job

  # VIRTUAL GETTER: Is this task complete? (for the checkbox)
  def completed
    completed_at.present?
  end

  # VIRTUAL SETTER: Update completed_at based on the checkbox
  def completed=(value)
    # The form sends "1" for checked and "0" for unchecked
    if value == "1"
      self.completed_at = Time.current
    else
      self.completed_at = nil
    end
  end
end