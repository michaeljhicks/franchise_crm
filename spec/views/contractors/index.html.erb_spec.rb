require 'rails_helper'

RSpec.describe "contractors/index", type: :view do
  before(:each) do
    assign(:contractors, [
      Contractor.create!(
        name: "Name",
        phone_number: "Phone Number"
      ),
      Contractor.create!(
        name: "Name",
        phone_number: "Phone Number"
      )
    ])
  end

  it "renders a list of contractors" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone Number".to_s), count: 2
  end
end
