# db/migrate/xxxxxxxx_migrate_contacts_and_remove_old_columns.rb
class MigrateContactsAndRemoveOldColumns < ActiveRecord::Migration[7.1]
  
  # --- THE FIX ---
  # Define the temporary class here, OUTSIDE the up/down methods.
  class TmpContact < ApplicationRecord
    self.table_name = :contacts
  end

  def up
    # Now, the rest of the 'up' method can use TmpContact
    Customer.find_each do |customer|
      # Create a contact from the 'main_contact' fields if a name is present
      if customer.main_contact_name.present?
        TmpContact.create!(
          customer_id: customer.id,
          name: customer.main_contact_name,
          phone: customer.main_contact_phone,
          email: customer.main_contact_email,
          role: "Main"
        )
      end
      # Create a contact from the 'other_contact' fields if a name is present
      if customer.other_contact_name.present?
        TmpContact.create!(
          customer_id: customer.id,
          name: customer.other_contact_name,
          phone: customer.other_contact_phone,
          role: "Other"
        )
      end
    end

    # Now that the data is moved, we can safely remove the old columns
    remove_column :customers, :main_contact_name, :string
    remove_column :customers, :main_contact_phone, :string
    remove_column :customers, :main_contact_email, :string
    remove_column :customers, :other_contact_name, :string
    remove_column :customers, :other_contact_phone, :string
  end

  def down
    # This makes the migration reversible (good practice)
    add_column :customers, :main_contact_name, :string
    add_column :customers, :main_contact_phone, :string
    add_column :customers, :main_contact_email, :string
    add_column :customers, :other_contact_name, :string
    add_column :customers, :other_contact_phone, :string
  end
end