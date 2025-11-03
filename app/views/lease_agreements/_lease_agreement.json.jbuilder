json.extract! lease_agreement, :id, :lease_start_date, :lease_end_date, :lease_rate, :user_id, :customer_id, :machine_id, :created_at, :updated_at
json.url lease_agreement_url(lease_agreement, format: :json)
