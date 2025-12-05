class AddGmailAliasToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :gmail_alias, :string
  end
end
