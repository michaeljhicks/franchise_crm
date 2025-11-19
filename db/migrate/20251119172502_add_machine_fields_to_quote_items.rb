class AddMachineFieldsToQuoteItems < ActiveRecord::Migration[8.0]
  def change
    add_column :quote_items, :machine_make, :string
    add_column :quote_items, :machine_model, :string
    add_column :quote_items, :bin_make, :string
    add_column :quote_items, :bin_model, :string
  end
end
