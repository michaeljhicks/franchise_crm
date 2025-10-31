require 'rails_helper'

RSpec.describe "prospects/new", type: :view do
  before(:each) do
    assign(:prospect, Prospect.new(
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
    ))
  end

  it "renders new prospect form" do
    render

    assert_select "form[action=?][method=?]", prospects_path, "post" do

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
