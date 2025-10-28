class CreateMachines < ActiveRecord::Migration[8.0]
  def change
    create_table :machines do |t|
      t.string :machine_make
      t.string :machine_model
      t.string :machine_serial_number
      t.string :machine_type
      t.string :bin_make
      t.string :bin_model
      t.string :bin_serial_number
      t.date :purchase_date
      t.date :install_date
      t.string :status
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
