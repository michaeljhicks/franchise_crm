require 'rails_helper'

RSpec.describe "customers/index", type: :view do
  before(:each) do
    assign(:customers, [
      Customer.create!(
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
      ),
      Customer.create!(
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
      )
    ])
  end

  it "renders a list of customers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Business Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Street Address".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Zip".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Main Contact Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Main Contact Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Main Contact Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
