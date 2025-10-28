FactoryBot.define do
  factory :customer do
    business_name { "MyString" }
    street_address { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { "MyString" }
    main_contact_name { "MyString" }
    main_contact_phone { "MyString" }
    main_contact_email { "MyString" }
    customer_since { "2025-10-28" }
    status { "MyString" }
    notes { "MyText" }
    user { nil }
  end
end
