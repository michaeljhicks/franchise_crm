class LeaseAgreementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lease_agreement, only: %i[ show edit update destroy generate_document ]
  before_action :resolve_and_convert_owner, only: [:create]

  def generate_document
    service = GoogleDocsService.new(current_user)
    new_document_id = service.generate_lease_from_template(@lease_agreement)
    doc_url = "https://docs.google.com/document/d/#{new_document_id}/edit"

    redirect_to doc_url, allow_other_host: true, notice: "Lease document was successfully generated!"
  end

  def index
    @lease_agreements = current_user.lease_agreements.includes(:customer, :machine)
    @pagy, @lease_agreements = pagy(@lease_agreements.order(lease_start_date: :desc))
  end

  def show
  end

  def new
    @lease_agreement = current_user.lease_agreements.build(customer_id: params[:customer_id])

    prospects = current_user.prospects.order(:business_name)
    customers = current_user.customers.order(:business_name)

    @grouped_options = [
      ['Prospects', prospects.map { |p| [p.business_name, "prospect_#{p.id}"] }],
      ['Customers', customers.map { |c| [c.business_name, "customer_#{c.id}"] }]
    ]
  end

  def edit
    # @customers = current_user.customers.order(:business_name)
    # @machines  = current_user.machines.order(:machine_model)
    @available_machines = current_user.machines.order(:machine_model)
  end

  def create
    # @customer is set by resolve_and_convert_owner
    @lease_agreement       = @customer.lease_agreements.build(lease_agreement_params)
    @lease_agreement.user  = current_user

    if @lease_agreement.save
      redirect_to @lease_agreement, notice: "Lease agreement was successfully created."
    else
      prospects = current_user.prospects.order(:business_name)
      customers = current_user.customers.order(:business_name)

      @grouped_options = [
        ['Prospects', prospects.map { |p| [p.business_name, "prospect_#{p.id}"] }],
        ['Customers', customers.map { |c| [c.business_name, "customer_#{c.id}"] }]
      ]

      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @lease_agreement.update(lease_agreement_params)
        format.html { redirect_to @lease_agreement, notice: "Lease agreement was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @lease_agreement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lease_agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lease_agreement.destroy!

    respond_to do |format|
      format.html { redirect_to lease_agreements_path, notice: "Lease agreement was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_lease_agreement
      @lease_agreement = current_user.lease_agreements.includes(:customer, :machine).find(params[:id])
    end

    def resolve_and_convert_owner
      identifier = params[:lease_agreement].delete(:owner_identifier)

      if identifier.blank?
        prospects = current_user.prospects.order(:business_name)
        customers = current_user.customers.order(:business_name)

        @grouped_options = [
          ['Prospects', prospects.map { |p| [p.business_name, "prospect_#{p.id}"] }],
          ['Customers', customers.map { |c| [c.business_name, "customer_#{c.id}"] }]
        ]

        @lease_agreement = current_user.lease_agreements.build(lease_agreement_params)
        @lease_agreement.errors.add(:base, "You must select a Prospect or Customer.")
        render :new, status: :unprocessable_entity and return
      end

      owner_type, owner_id = identifier.split('_')

      if owner_type == 'prospect'
        prospect = current_user.prospects.find(owner_id)
        @customer = Customer.create!(
          business_name:    prospect.business_name,
          street_address:   prospect.business_location,
          user:             current_user,
          contacts_attributes: [{
            name:  prospect.contact_name,
            email: prospect.email,
            phone: prospect.phone,
            role:  "Primary"
          }]
        )
        prospect.destroy
      else
        @customer = current_user.customers.find(owner_id)
      end

      params[:lease_agreement][:customer_id] = @customer.id
    end

    def lease_agreement_params
      params.require(:lease_agreement).permit(
        :lease_start_date,
        :lease_end_date,
        :lease_rate,
        :customer_id,
        :machine_id,
        :filter_kit,
        :status,
        :machine_details,
        :bin_details
      )
    end
end
