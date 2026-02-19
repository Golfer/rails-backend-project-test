# frozen_string_literal: true

FactoryBot.define do
  factory :vendor do
    association :company
    name { Faker::Company.name }
    contact_info { {} }

    trait :with_contact do
      contact_info { { email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number } }
    end
  end
end
