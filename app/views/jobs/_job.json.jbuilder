json.extract! job, :id, :scheduled_date_time, :completed_date_time, :job_type, :status, :contractor_notes, :internal_notes, :customer_id, :machine_id, :user_id, :contractor_id, :created_at, :updated_at
json.url job_url(job, format: :json)
