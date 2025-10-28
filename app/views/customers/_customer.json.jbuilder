json.extract! customer, :id, :business_name, :street_address, :city, :state, :zip, :main_contact_name, :main_contact_phone, :main_contact_email, :customer_since, :status, :notes, :user_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
