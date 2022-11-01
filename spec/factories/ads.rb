FactoryBot.define do
  factory :ad do
    description { "MyString" }
    price { 1 }
    stage { 1 }
    reason_for_rejection { "MyString" }
  end
end
