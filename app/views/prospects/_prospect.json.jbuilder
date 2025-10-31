json.extract! prospect, :id, :contact_name, :business_name, :business_location, :email, :phone, :notes, :business_type, :hours, :ice_usage, :ice_shape, :seating_capacity, :special_circumstances, :user_id, :created_at, :updated_at
json.url prospect_url(prospect, format: :json)
