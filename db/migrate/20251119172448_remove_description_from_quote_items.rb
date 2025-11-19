class RemoveDescriptionFromQuoteItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :quote_items, :description, :string
  end
end
