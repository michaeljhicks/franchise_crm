class AddGoogleEventIdToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :jobs, :google_event_id, :string
  end
end
