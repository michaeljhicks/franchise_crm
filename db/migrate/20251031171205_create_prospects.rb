class CreateProspects < ActiveRecord::Migration[8.0]
  def change
    create_table :prospects do |t|
      t.string :contact_name
      t.string :business_name
      t.string :business_location
      t.string :email
      t.string :phone
      t.text :notes
      t.text :business_type
      t.text :hours
      t.text :ice_usage
      t.text :ice_shape
      t.text :seating_capacity
      t.text :special_circumstances
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
