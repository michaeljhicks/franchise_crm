FactoryBot.define do
  factory :quote do
    expiration_date { "2025-11-14" }
    prospect { nil }
    user { nil }
  end
end
