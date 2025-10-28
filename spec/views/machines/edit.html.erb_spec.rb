require 'rails_helper'

RSpec.describe "machines/edit", type: :view do
  let(:machine) {
    Machine.create!(
      machine_make: "MyString",
      machine_model: "MyString",
      machine_serial_number: "MyString",
      machine_type: "MyString",
      bin_make: "MyString",
      bin_model: "MyString",
      bin_serial_number: "MyString",
      status: "MyString",
      customer: nil
    )
  }

  before(:each) do
    assign(:machine, machine)
  end

  it "renders the edit machine form" do
    render

    assert_select "form[action=?][method=?]", machine_path(machine), "post" do

      assert_select "input[name=?]", "machine[machine_make]"

      assert_select "input[name=?]", "machine[machine_model]"

      assert_select "input[name=?]", "machine[machine_serial_number]"

      assert_select "input[name=?]", "machine[machine_type]"

      assert_select "input[name=?]", "machine[bin_make]"

      assert_select "input[name=?]", "machine[bin_model]"

      assert_select "input[name=?]", "machine[bin_serial_number]"

      assert_select "input[name=?]", "machine[status]"

      assert_select "input[name=?]", "machine[customer_id]"
    end
  end
end
