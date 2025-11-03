require 'rails_helper'

RSpec.describe "lease_agreements/show", type: :view do
  before(:each) do
    assign(:lease_agreement, LeaseAgreement.create!(
      lease_rate: "9.99",
      user: nil,
      customer: nil,
      machine: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
