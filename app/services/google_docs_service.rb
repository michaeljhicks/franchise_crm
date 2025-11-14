# app/services/google_docs_service.rb
require 'google/apis/docs_v1'
require 'google/apis/drive_v3'
require 'googleauth'

class GoogleDocsService
  TEMPLATE_ID = '18-oXGeW2eTHJK_Qb9cfH3Inj9AlXl7MtfgyEJX6_PVg'

  def initialize(user)
    @user = user
    @docs_service = Google::Apis::DocsV1::DocsService.new
    @docs_service.authorization = GoogleCredentials.new(user).credentials
    @drive_service = Google::Apis::DriveV3::DriveService.new
    @drive_service.authorization = GoogleCredentials.new(user).credentials
  end

  # app/services/google_docs_service.rb
  def generate_lease_from_template(lease_agreement)
    customer = lease_agreement.customer
    machine = lease_agreement.machine
    franchisee = lease_agreement.user

    # 1. Copy the template file in Google Drive
    new_document_name = "Lease Agreement - #{customer.business_name}"
    copied_file_request = Google::Apis::DriveV3::File.new(name: new_document_name)

    # --- THIS IS THE FIX ---
    # Remove the `file_object:` keyword. Pass the request object directly.
    copied_file = @drive_service.copy_file(TEMPLATE_ID, copied_file_request)
    new_document_id = copied_file.id

    # 2. Prepare the replacement requests for the Google Docs API
    # In app/services/google_docs_service.rb

    franchisee_address = [franchisee.address, "#{franchisee.city}, #{franchisee.state} #{franchisee.zip_code}"].compact.join("\n")

    requests = [
    # --- Lessor Block ---
    { replace_all_text: { contains_text: { text: '{{Branch Location}}', match_case: false }, replace_text: franchisee_address || '' } },

    # --- Lessee & Equipment Location Blocks (they are the same) ---
    { replace_all_text: { contains_text: { text: '{{Company Name}}', match_case: false }, replace_text: customer.business_name || '' } },
    { replace_all_text: { contains_text: { text: '{{Main Contact Name}}', match_case: false }, replace_text: customer.contacts.first&.name || '' } },
    { replace_all_text: { contains_text: { text: '{{Company Street Address}}', match_case: false }, replace_text: customer.street_address || '' } },
    { replace_all_text: { contains_text: { text: '{{Equipment Address}}', match_case: false }, replace_text: customer.street_address || '' } }, # Same data, different placeholder
    { replace_all_text: { contains_text: { text: '{{Email}}', match_case: false }, replace_text: customer.contacts.first&.email || '' } },
    { replace_all_text: { contains_text: { text: '{{Phone}}', match_case: false }, replace_text: customer.contacts.first&.phone || '' } },

    # --- Equipment Description ---
    # Best if you change the doc to have single placeholders like {{Ice Machine Description}}
    { replace_all_text: { contains_text: { text: '{{Other Manufacturer}}{{Model}}{{Other Model}} Ice Machine', match_case: false },
      # If a machine is assigned, use its data. Otherwise, use the temporary details.
      replace_text: lease_agreement.machine.present? ? "#{lease_agreement.machine.machine_make} #{lease_agreement.machine.machine_model}" : lease_agreement.machine_details } },
    { replace_all_text: {  contains_text: { text: '{{Bin}} Ice Bin', match_case: false }, replace_text: lease_agreement.machine.present? ? "#{lease_agreement.machine.bin_make} #{lease_agreement.machine.bin_model}" : lease_agreement.bin_details
      }
    },
    { replace_all_text: { contains_text: { text: '{{Filter Kit}}{{Other Filter}} Water Filtration System', match_case: false },
        replace_text: lease_agreement.filter_kit || 'N/A'
      }
    },
    # You'll need to add filter info to your `Machine` model to fill in the rest of this

    # --- Term & Rent Block ---
    { replace_all_text: { contains_text: { text: '{{Lease Term in Words}}', match_case: false }, replace_text: 'Thirty-Six' } }, # This will need a helper to convert numbers to words
    { replace_all_text: { contains_text: { text: '{{Lease Term}}', match_case: false }, replace_text: '36' } }, # Or add a `term` column to your LeaseAgreement model
    { replace_all_text: { contains_text: { text: '{{Commencement Date}}', match_case: false }, replace_text: lease_agreement.lease_start_date&.strftime('%B %d, %Y') || '' } },
    { replace_all_text: { contains_text: { text: '{{Worded Number}}', match_case: false }, replace_text: lease_agreement.lease_rate_in_words} },
    { replace_all_text: { contains_text: { text: '${{Term Price}}', match_case: false }, replace_text: lease_agreement.lease_rate.to_s } }
    ]
    
    # 3. Send the request to the Google Docs API
    batch_update_request = Google::Apis::DocsV1::BatchUpdateDocumentRequest.new(requests: requests)
    @docs_service.batch_update_document(new_document_id, batch_update_request)

    # 4. Return the ID of the new document
    return new_document_id
  end
end