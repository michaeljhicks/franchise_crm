class Job < ApplicationRecord
  belongs_to :customer
  belongs_to :machine
  belongs_to :user
  belongs_to :contractor
end
