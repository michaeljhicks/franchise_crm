require 'rails_helper'

RSpec.describe "quotes/edit", type: :view do
  let(:quote) {
    Quote.create!(
      prospect: nil,
      user: nil
    )
  }

  before(:each) do
    assign(:quote, quote)
  end

  it "renders the edit quote form" do
    render

    assert_select "form[action=?][method=?]", quote_path(quote), "post" do

      assert_select "input[name=?]", "quote[prospect_id]"

      assert_select "input[name=?]", "quote[user_id]"
    end
  end
end
