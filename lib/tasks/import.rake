require 'csv'

namespace :import do
  # This is the master task. It runs the other tasks in the correct order.
  desc "Import all data from CSV files"
  task all: :environment do
    Rake::Task['import:customers'].invoke
    Rake::Task['import:machines'].invoke
    puts "All data imported successfully!"
  end

  # Your existing, robust task for importing customers.
  desc "Import customers from lib/tasks/data/customers.csv"
  task customers: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'data', 'customers.csv')

    unless User.exists?(1)
      puts "ERROR: User with ID 1 not found. Please create this user before importing customers."
      return
    end

    puts "Starting to import customers from #{csv_file_path}..."

    ActiveRecord::Base.transaction do
      CSV.foreach(csv_file_path, headers: true) do |row|
        begin
          Customer.find_or_create_by!(business_name: row['business_name']) do |customer|
            puts "Creating new customer: #{row['business_name']}"
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
          puts "SKIPPED (Validation Failed): Customer '#{row['business_name']}' - #{e.message}"
        rescue => e
          puts "SKIPPED (Error): Customer '#{row['business_name']}' - #{e.message}"
        end
      end
    end

    puts "Customer import finished."
    puts "Total customers in database now: #{Customer.count}"
  end

  # The new task for importing machines from your MachinesDB.csv file.
  desc "Import machines from lib/tasks/data/MachinesDB.csv"
  task machines: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'data', 'MachinesDB.csv')

    puts "Starting to import machines from #{csv_file_path}..."

    ActiveRecord::Base.transaction do
      CSV.foreach(csv_file_path, headers: true) do |row|
        # Skip rows that don't have a serial number, as it's our unique identifier.
        if row['machine_serial_number'].blank?
          puts "SKIPPED (Missing Serial Number): Row for customer_id #{row['customer_id']}"
          next
        end

        begin
          # Use the serial number to find existing machines to prevent duplicates.
          Machine.find_or_create_by!(machine_serial_number: row['machine_serial_number']) do |machine|
            puts "Creating new machine: #{row['machine_make']} #{row['machine_model']} (S/N: #{row['machine_serial_number']})"

            # assign_attributes is a convenient way to map all columns at once.
            machine.assign_attributes(row.to_hash)
          end
        rescue ActiveRecord::RecordInvalid => e
          puts "SKIPPED (Validation Failed): Machine S/N '#{row['machine_serial_number']}' - #{e.message}"
        rescue => e
          puts "SKIPPED (Error): Machine S/N '#{row['machine_serial_number']}' - #{e.message}"
        end
      end
    end

    puts "Machine import finished."
    puts "Total machines in database now: #{Machine.count}"
  end
end