class AddStatusToLeaseAgreements < ActiveRecord::Migration[8.0]
  def change
    add_column :lease_agreements, :status, :integer, default: 0, null: false
  end
end
