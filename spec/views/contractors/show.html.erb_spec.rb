require 'rails_helper'

RSpec.describe "contractors/show", type: :view do
  before(:each) do
    assign(:contractor, Contractor.create!(
      name: "Name",
      phone_number: "Phone Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone Number/)
  end
end
