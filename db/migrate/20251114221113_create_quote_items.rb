class CreateQuoteItems < ActiveRecord::Migration[8.0]
  def change
    create_table :quote_items do |t|
      t.string :description
      t.string :ice_production
      t.string :ice_storage
      t.string :lease_rate
      t.references :quote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
