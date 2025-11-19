require 'rails_helper'

RSpec.describe "quotes/new", type: :view do
  before(:each) do
    assign(:quote, Quote.new(
      prospect: nil,
      user: nil
    ))
  end

  it "renders new quote form" do
    render

    assert_select "form[action=?][method=?]", quotes_path, "post" do

      assert_select "input[name=?]", "quote[prospect_id]"

      assert_select "input[name=?]", "quote[user_id]"
    end
  end
end
