require 'rails_helper'

RSpec.describe "machines/show", type: :view do
  before(:each) do
    assign(:machine, Machine.create!(
      machine_make: "Machine Make",
      machine_model: "Machine Model",
      machine_serial_number: "Machine Serial Number",
      machine_type: "Machine Type",
      bin_make: "Bin Make",
      bin_model: "Bin Model",
      bin_serial_number: "Bin Serial Number",
      status: "Status",
      customer: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Machine Make/)
    expect(rendered).to match(/Machine Model/)
    expect(rendered).to match(/Machine Serial Number/)
    expect(rendered).to match(/Machine Type/)
    expect(rendered).to match(/Bin Make/)
    expect(rendered).to match(/Bin Model/)
    expect(rendered).to match(/Bin Serial Number/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
  end
end
