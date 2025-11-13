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
end