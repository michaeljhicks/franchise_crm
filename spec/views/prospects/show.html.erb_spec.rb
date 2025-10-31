require 'rails_helper'

RSpec.describe "prospects/show", type: :view do
  before(:each) do
    assign(:prospect, Prospect.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Contact Name/)
    expect(rendered).to match(/Business Name/)
    expect(rendered).to match(/Business Location/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
