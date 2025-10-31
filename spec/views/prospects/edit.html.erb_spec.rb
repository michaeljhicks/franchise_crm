require 'rails_helper'

RSpec.describe "prospects/edit", type: :view do
  let(:prospect) {
    Prospect.create!(
      contact_name: "MyString",
      business_name: "MyString",
      business_location: "MyString",
      email: "MyString",
      phone: "MyString",
      notes: "MyText",
      business_type: "MyText",
      hours: "MyText",
      ice_usage: "MyText",
      ice_shape: "MyText",
      seating_capacity: "MyText",
      special_circumstances: "MyText",
      user: nil
    )
  }

  before(:each) do
    assign(:prospect, prospect)
  end

  it "renders the edit prospect form" do
    render

    assert_select "form[action=?][method=?]", prospect_path(prospect), "post" do

      assert_select "input[name=?]", "prospect[contact_name]"

      assert_select "input[name=?]", "prospect[business_name]"

      assert_select "input[name=?]", "prospect[business_location]"

      assert_select "input[name=?]", "prospect[email]"

      assert_select "input[name=?]", "prospect[phone]"

      assert_select "textarea[name=?]", "prospect[notes]"

      assert_select "textarea[name=?]", "prospect[business_type]"

      assert_select "textarea[name=?]", "prospect[hours]"

      assert_select "textarea[name=?]", "prospect[ice_usage]"

      assert_select "textarea[name=?]", "prospect[ice_shape]"

      assert_select "textarea[name=?]", "prospect[seating_capacity]"

      assert_select "textarea[name=?]", "prospect[special_circumstances]"

      assert_select "input[name=?]", "prospect[user_id]"
    end
  end
end
