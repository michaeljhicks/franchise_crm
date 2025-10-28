class Customer < ApplicationRecord
  belongs_to :user # The franchise
  has_many :machines, dependent: :destroy
  has_many :jobs, dependent: :destroy
end