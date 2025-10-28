require 'rails_helper'

RSpec.describe "customers/edit", type: :view do
  let(:customer) {
    Customer.create!(
      business_name: "MyString",
      street_address: "MyString",
      city: "MyString",
      state: "MyString",
      zip: "MyString",
      main_contact_name: "MyString",
      main_contact_phone: "MyString",
      main_contact_email: "MyString",
      status: "MyString",
      notes: "MyText",
      user: nil
    )
  }

  before(:each) do
    assign(:customer, customer)
  end

  it "renders the edit customer form" do
    render

    assert_select "form[action=?][method=?]", customer_path(customer), "post" do

      assert_select "input[name=?]", "customer[business_name]"

      assert_select "input[name=?]", "customer[street_address]"

      assert_select "input[name=?]", "customer[city]"

      assert_select "input[name=?]", "customer[state]"

      assert_select "input[name=?]", "customer[zip]"

      assert_select "input[name=?]", "customer[main_contact_name]"

      assert_select "input[name=?]", "customer[main_contact_phone]"

      assert_select "input[name=?]", "customer[main_contact_email]"

      assert_select "input[name=?]", "customer[status]"

      assert_select "textarea[name=?]", "customer[notes]"

      assert_select "input[name=?]", "customer[user_id]"
    end
  end
end
