require 'rails_helper'

RSpec.describe "lease_agreements/edit", type: :view do
  let(:lease_agreement) {
    LeaseAgreement.create!(
      lease_rate: "9.99",
      user: nil,
      customer: nil,
      machine: nil
    )
  }

  before(:each) do
    assign(:lease_agreement, lease_agreement)
  end

  it "renders the edit lease_agreement form" do
    render

    assert_select "form[action=?][method=?]", lease_agreement_path(lease_agreement), "post" do

      assert_select "input[name=?]", "lease_agreement[lease_rate]"

      assert_select "input[name=?]", "lease_agreement[user_id]"

      assert_select "input[name=?]", "lease_agreement[customer_id]"

      assert_select "input[name=?]", "lease_agreement[machine_id]"
    end
  end
end
