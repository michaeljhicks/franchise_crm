require 'rails_helper'

RSpec.describe "jobs/edit", type: :view do
  let(:job) {
    Job.create!(
      job_type: "MyString",
      status: "MyString",
      contractor_notes: "MyText",
      internal_notes: "MyText",
      customer: nil,
      machine: nil,
      user: nil,
      contractor: nil
    )
  }

  before(:each) do
    assign(:job, job)
  end

  it "renders the edit job form" do
    render

    assert_select "form[action=?][method=?]", job_path(job), "post" do

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
