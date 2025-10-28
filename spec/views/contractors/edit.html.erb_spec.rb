require 'rails_helper'

RSpec.describe "contractors/edit", type: :view do
  let(:contractor) {
    Contractor.create!(
      name: "MyString",
      phone_number: "MyString"
    )
  }

  before(:each) do
    assign(:contractor, contractor)
  end

  it "renders the edit contractor form" do
    render

    assert_select "form[action=?][method=?]", contractor_path(contractor), "post" do

      assert_select "input[name=?]", "contractor[name]"

      assert_select "input[name=?]", "contractor[phone_number]"
    end
  end
end
