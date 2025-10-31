FactoryBot.define do
  factory :prospect do
    contact_name { "MyString" }
    business_name { "MyString" }
    business_location { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    notes { "MyText" }
    business_type { "MyText" }
    hours { "MyText" }
    ice_usage { "MyText" }
    ice_shape { "MyText" }
    seating_capacity { "MyText" }
    special_circumstances { "MyText" }
    user { nil }
  end
end
