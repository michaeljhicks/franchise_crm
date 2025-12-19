class Customer < ApplicationRecord
  belongs_to :user
  has_many :machines, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :lease_agreements, dependent: :destroy

  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank

  validates :business_name, presence: true

  enum :status, {
    active: 'Active',
    inactive: 'Inactive'
  }

  def full_address
    [street_address, city, state, zip].compact.join(', ')
  end

  geocoded_by :full_address

  after_validation :geocode, if: ->(obj){ obj.street_address.present? && obj.street_address_changed? }
end