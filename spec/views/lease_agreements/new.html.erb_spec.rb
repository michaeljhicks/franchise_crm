require 'rails_helper'

RSpec.describe "lease_agreements/new", type: :view do
  before(:each) do
    assign(:lease_agreement, LeaseAgreement.new(
      lease_rate: "9.99",
      user: nil,
      customer: nil,
      machine: nil
    ))
  end

  it "renders new lease_agreement form" do
    render

    assert_select "form[action=?][method=?]", lease_agreements_path, "post" do

      assert_select "input[name=?]", "lease_agreement[lease_rate]"

      assert_select "input[name=?]", "lease_agreement[user_id]"

      assert_select "input[name=?]", "lease_agreement[customer_id]"

      assert_select "input[name=?]", "lease_agreement[machine_id]"
    end
  end
end
