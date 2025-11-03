class AddUserToContractors < ActiveRecord::Migration[7.1]
  def change
    # Step 1: Add the user_id column, but allow it to be null temporarily.
    add_reference :contractors, :user, foreign_key: true, null: true

    # Step 2: Find the first user to act as the default owner.
    # This is safe in a migration because we know at least one user must exist.
    default_user = User.first
    
    # If a user exists, update all existing contractors to belong to them.
    if default_user
      # This runs a single SQL UPDATE command.
      Contractor.where(user_id: nil).update_all(user_id: default_user.id)
    end
    
    # Step 3: Now that all rows are populated, change the column to be NOT NULL.
    change_column_null :contractors, :user_id, false
  end
end