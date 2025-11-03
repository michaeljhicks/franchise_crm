require 'rails_helper'

RSpec.describe "lease_agreements/index", type: :view do
  before(:each) do
    assign(:lease_agreements, [
      LeaseAgreement.create!(
        lease_rate: "9.99",
        user: nil,
        customer: nil,
        machine: nil
      ),
      LeaseAgreement.create!(
        lease_rate: "9.99",
        user: nil,
        customer: nil,
        machine: nil
      )
    ])
  end

  it "renders a list of lease_agreements" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
