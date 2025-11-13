FactoryBot.define do
  factory :contact do
    name { "MyString" }
    role { "MyString" }
    phone { "MyString" }
    email { "MyString" }
    customer { nil }
  end
end
