class AddFilterKitToLeaseAgreements < ActiveRecord::Migration[8.0]
  def change
    add_column :lease_agreements, :filter_kit, :string
  end
end
