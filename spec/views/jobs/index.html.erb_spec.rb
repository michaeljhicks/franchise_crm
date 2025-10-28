require 'rails_helper'

RSpec.describe "jobs/index", type: :view do
  before(:each) do
    assign(:jobs, [
      Job.create!(
        job_type: "Job Type",
        status: "Status",
        contractor_notes: "MyText",
        internal_notes: "MyText",
        customer: nil,
        machine: nil,
        user: nil,
        contractor: nil
      ),
      Job.create!(
        job_type: "Job Type",
        status: "Status",
        contractor_notes: "MyText",
        internal_notes: "MyText",
        customer: nil,
        machine: nil,
        user: nil,
        contractor: nil
      )
    ])
  end

  it "renders a list of jobs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Job Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
