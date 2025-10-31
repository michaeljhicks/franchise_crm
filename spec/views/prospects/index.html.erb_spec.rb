require 'rails_helper'

RSpec.describe "prospects/index", type: :view do
  before(:each) do
    assign(:prospects, [
      Prospect.create!(
        contact_name: "Contact Name",
        business_name: "Business Name",
        business_location: "Business Location",
        email: "Email",
        phone: "Phone",
        notes: "MyText",
        business_type: "MyText",
        hours: "MyText",
        ice_usage: "MyText",
        ice_shape: "MyText",
        seating_capacity: "MyText",
        special_circumstances: "MyText",
        user: nil
      ),
      Prospect.create!(
        contact_name: "Contact Name",
        business_name: "Business Name",
        business_location: "Business Location",
        email: "Email",
        phone: "Phone",
        notes: "MyText",
        business_type: "MyText",
        hours: "MyText",
        ice_usage: "MyText",
        ice_shape: "MyText",
        seating_capacity: "MyText",
        special_circumstances: "MyText",
        user: nil
      )
    ])
  end

  it "renders a list of prospects" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Contact Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Business Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Business Location".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
