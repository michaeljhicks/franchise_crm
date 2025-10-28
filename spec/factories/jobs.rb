FactoryBot.define do
  factory :job do
    scheduled_date_time { "2025-10-28 13:17:57" }
    completed_date_time { "2025-10-28 13:17:57" }
    job_type { "MyString" }
    status { "MyString" }
    contractor_notes { "MyText" }
    internal_notes { "MyText" }
    customer { nil }
    machine { nil }
    user { nil }
    contractor { nil }
  end
end
