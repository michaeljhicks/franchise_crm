class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :role
      t.string :phone
      t.string :email
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
