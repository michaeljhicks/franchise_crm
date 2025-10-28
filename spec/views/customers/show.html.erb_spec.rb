require 'rails_helper'

RSpec.describe "customers/show", type: :view do
  before(:each) do
    assign(:customer, Customer.create!(
      business_name: "Business Name",
      street_address: "Street Address",
      city: "City",
      state: "State",
      zip: "Zip",
      main_contact_name: "Main Contact Name",
      main_contact_phone: "Main Contact Phone",
      main_contact_email: "Main Contact Email",
      status: "Status",
      notes: "MyText",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Business Name/)
    expect(rendered).to match(/Street Address/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zip/)
    expect(rendered).to match(/Main Contact Name/)
    expect(rendered).to match(/Main Contact Phone/)
    expect(rendered).to match(/Main Contact Email/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
