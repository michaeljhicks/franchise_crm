json.extract! machine, :id, :machine_make, :machine_model, :machine_serial_number, :machine_type, :bin_make, :bin_model, :bin_serial_number, :purchase_date, :install_date, :status, :customer_id, :created_at, :updated_at
json.url machine_url(machine, format: :json)
