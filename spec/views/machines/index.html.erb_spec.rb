require 'rails_helper'

RSpec.describe "machines/index", type: :view do
  before(:each) do
    assign(:machines, [
      Machine.create!(
        machine_make: "Machine Make",
        machine_model: "Machine Model",
        machine_serial_number: "Machine Serial Number",
        machine_type: "Machine Type",
        bin_make: "Bin Make",
        bin_model: "Bin Model",
        bin_serial_number: "Bin Serial Number",
        status: "Status",
        customer: nil
      ),
      Machine.create!(
        machine_make: "Machine Make",
        machine_model: "Machine Model",
        machine_serial_number: "Machine Serial Number",
        machine_type: "Machine Type",
        bin_make: "Bin Make",
        bin_model: "Bin Model",
        bin_serial_number: "Bin Serial Number",
        status: "Status",
        customer: nil
      )
    ])
  end

  it "renders a list of machines" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Machine Make".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Machine Model".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Machine Serial Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Machine Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Bin Make".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Bin Model".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Bin Serial Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
