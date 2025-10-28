class CreateCustomers < ActiveRecord::Migration[8.0]
  def up
    return if table_exists?(:customers)

    create_table :customers do |t|
      t.string :business_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :main_contact_name
      t.string :main_contact_phone
      t.string :main_contact_email
      t.date   :customer_since
      t.string :status
      t.text   :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :customers if table_exists?(:customers)
  end
end
