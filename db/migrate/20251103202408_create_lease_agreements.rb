class CreateLeaseAgreements < ActiveRecord::Migration[8.0]
  def change
    create_table :lease_agreements do |t|
      t.date :lease_start_date
      t.date :lease_end_date
      t.decimal :lease_rate, precision: 8, scale: 2
      t.references :user, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :machine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
