class LeaseAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  belongs_to :machine
end
