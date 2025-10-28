require 'rails_helper'

RSpec.describe "jobs/show", type: :view do
  before(:each) do
    assign(:job, Job.create!(
      job_type: "Job Type",
      status: "Status",
      contractor_notes: "MyText",
      internal_notes: "MyText",
      customer: nil,
      machine: nil,
      user: nil,
      contractor: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Job Type/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
