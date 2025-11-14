class LeaseAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  belongs_to :machine, optional: true

  enum :status, {
    pending: 0,
    active: 1,
    early_termination: 2,
    inactive: 3
  }

  def lease_rate_in_words
    # Return a default string if the rate is missing, to prevent errors.
    return "zero dollars and zero cents" unless lease_rate.present?

    # 1. Separate the dollars and cents from the decimal value.
    dollars = lease_rate.to_i
    cents = ((lease_rate - dollars) * 100).round

    # 2. Convert the integer parts to words using the new gem.
    #    The `hundreds_with_and: true` option adds the "and" (e.g., "one hundred AND ten").
    dollars_in_words = dollars.to_words(hundreds_with_and: true)
    cents_in_words = cents.to_words

    # 3. Handle pluralization of "dollar" and "cent".
    dollar_string = dollars == 1 ? "dollar" : "dollars"
    cent_string = cents == 1 ? "cent" : "cents"

    # 4. Combine everything into the final, formatted string.
    "#{dollars_in_words} #{dollar_string} and #{cents_in_words} #{cent_string}"
  end

  # Calculate the total duration of the lease in days.
  def total_duration_in_days
    return 0 unless lease_start_date.present? && lease_end_date.present?
    (lease_end_date - lease_start_date).to_i
  end

  # Calculate how many days have passed since the lease started.
  def days_elapsed
    return 0 unless lease_start_date.present?
    # Don't show negative days if the lease starts in the future.
    [0, (Time.zone.today - lease_start_date).to_i].max
  end

  # Calculate how many days are left until the lease ends.
  def days_remaining
    return 0 unless lease_end_date.present?
    # Don't show negative days if the lease has already ended.
    [0, (lease_end_date - Time.zone.today).to_i].max
  end

  # Calculate the completion percentage, used for the progress bar.
  def completion_percentage
    # Return 0 if the lease has no defined duration.
    return 0 if total_duration_in_days <= 0
    # Calculate the percentage and ensure it's between 0 and 100.
    ((days_elapsed.to_f / total_duration_in_days) * 100).clamp(0, 100)
  end
  
end