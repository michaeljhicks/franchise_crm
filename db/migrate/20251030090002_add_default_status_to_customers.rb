class AddDefaultStatusToCustomers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :customers, :status, from: nil, to: 'Active'
  end
end
