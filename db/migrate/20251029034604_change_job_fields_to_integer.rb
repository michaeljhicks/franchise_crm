class ChangeJobFieldsToInteger < ActiveRecord::Migration[7.1]
  def change
    # Change the job_type column to integer, with a default value of 0
    change_column :jobs, :job_type, :integer, using: 'job_type::integer', default: 0, null: false

    # Change the status column to integer, with a default value of 0
    change_column :jobs, :status, :integer, using: 'status::integer', default: 0, null: false
  end
end