FactoryBot.define do
  factory :machine do
    machine_make { "MyString" }
    machine_model { "MyString" }
    machine_serial_number { "MyString" }
    machine_type { "MyString" }
    bin_make { "MyString" }
    bin_model { "MyString" }
    bin_serial_number { "MyString" }
    purchase_date { "2025-10-28" }
    install_date { "2025-10-28" }
    status { "MyString" }
    customer { nil }
  end
end
