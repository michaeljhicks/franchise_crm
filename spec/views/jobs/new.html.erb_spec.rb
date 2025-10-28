require 'rails_helper'

RSpec.describe "jobs/new", type: :view do
  before(:each) do
    assign(:job, Job.new(
      job_type: "MyString",
      status: "MyString",
      contractor_notes: "MyText",
      internal_notes: "MyText",
      customer: nil,
      machine: nil,
      user: nil,
      contractor: nil
    ))
  end

  it "renders new job form" do
    render

    assert_select "form[action=?][method=?]", jobs_path, "post" do

      assert_select "input[name=?]", "job[job_type]"

      assert_select "input[name=?]", "job[status]"

      assert_select "textarea[name=?]", "job[contractor_notes]"

      assert_select "textarea[name=?]", "job[internal_notes]"

      assert_select "input[name=?]", "job[customer_id]"

      assert_select "input[name=?]", "job[machine_id]"

      assert_select "input[name=?]", "job[user_id]"

      assert_select "input[name=?]", "job[contractor_id]"
    end
  end
end
