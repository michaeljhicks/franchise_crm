class AddWarrantyAndLeaseRateToMachines < ActiveRecord::Migration[8.0]
  def change
    add_column :machines, :warranty_registered, :boolean, default: false
    add_column :machines, :lease_rate, :decimal, precision: 8, scale: 2, default: 0.0
  end

end
