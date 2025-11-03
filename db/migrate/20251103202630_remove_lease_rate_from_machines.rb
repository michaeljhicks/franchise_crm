class RemoveLeaseRateFromMachines < ActiveRecord::Migration[8.0]
  def change
    remove_column :machines, :lease_rate, :decimal
  end
end
