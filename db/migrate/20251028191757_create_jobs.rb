class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.datetime :scheduled_date_time
      t.datetime :completed_date_time
      t.string :job_type
      t.string :status
      t.text :contractor_notes
      t.text :internal_notes
      t.references :customer, null: false, foreign_key: true
      t.references :machine, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :contractor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
