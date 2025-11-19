class Quote < ApplicationRecord
  belongs_to :prospect
  belongs_to :user
  has_many :quote_items, dependent: :destroy
  accepts_nested_attributes_for :quote_items, allow_destroy: true, reject_if: :all_blank
end