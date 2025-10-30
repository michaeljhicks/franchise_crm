class Customer < ApplicationRecord
  belongs_to :user
  has_many :machines, dependent: :destroy
  has_many :jobs, dependent: :destroy

  validates :business_name, presence: true

  enum :status, {
    active: 'Active',
    inactive: 'Inactive'
  }
end