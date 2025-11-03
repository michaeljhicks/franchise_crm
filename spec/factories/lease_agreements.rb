FactoryBot.define do
  factory :lease_agreement do
    lease_start_date { "2025-11-03" }
    lease_end_date { "2025-11-03" }
    lease_rate { "9.99" }
    user { nil }
    customer { nil }
    machine { nil }
  end
end
