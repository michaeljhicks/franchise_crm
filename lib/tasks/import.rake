require 'csv'

namespace :import do
  desc "Import customers from lib/tasks/data/customers.csv"
  task customers: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'data', 'customers.csv')

    # Ensure the User with ID 1 exists before we start
    unless User.exists?(1)
      puts "ERROR: User with ID 1 not found. Please create this user before importing customers."
      return # Stop the task
    end

    puts "Starting to import customers from #{csv_file_path}..."

    # Use a transaction to ensure all customers are imported or none are.
    # If any single customer fails to save, the entire import will be rolled back.
    ActiveRecord::Base.transaction do
      CSV.foreach(csv_file_path, headers: true) do |row|
        begin
          # find_or_create_by! will search for a customer with this business_name.
          # If it doesn't find one, it will execute the block to create it.
          # The `!` at the end means it will raise an error if validation fails.
          Customer.find_or_create_by!(business_name: row['business_name']) do |customer|
            puts "Creating new customer: #{row['business_name']}"
            
            # Map the columns from the CSV to the attributes of the new customer object.
            # This block only runs if a NEW customer is being created.
            customer.street_address = row['street_address']
            customer.city = row['city']
            customer.state = row['state']
            customer.zip = row['zip']
            customer.main_contact_name = row['main_contact_name']
            customer.main_contact_phone = row['main_contact_phone']
            customer.main_contact_email = row['main_contact_email']
            customer.other_contact_name = row['other_contact_name']
            customer.other_contact_phone = row['other_contact_phone']
            customer.customer_since = row['customer_since']
            customer.status = row['status']
            customer.notes = row['notes']
            customer.user_id = row['user_id']
          end
        rescue ActiveRecord::RecordInvalid => e
          # If the `!` raises an error, we catch it and print a helpful message.
          puts "SKIPPED (Validation Failed): Customer '#{row['business_name']}' - #{e.message}"
        rescue => e
          # Catch any other unexpected errors.
          puts "SKIPPED (Error): Customer '#{row['business_name']}' - #{e.message}"
        end
      end
    end

    puts "Customer import finished."
    puts "Total customers in database now: #{Customer.count}"
  end
end