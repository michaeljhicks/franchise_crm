class Machine < ApplicationRecord
  belongs_to :customer
  has_one :user, through: :customer # A handy shortcut to get to the franchise user
  has_many :jobs, dependent: :destroy
end