class AddMachineDetailsToLeaseAgreements < ActiveRecord::Migration[8.0]
  def change
    add_column :lease_agreements, :machine_details, :string
    add_column :lease_agreements, :bin_details, :string
  end
end
