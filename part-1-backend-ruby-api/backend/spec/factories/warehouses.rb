# frozen_string_literal: true

FactoryBot.define do
  factory :warehouse do
    association :company
    name { Faker::Lorem.words(number: 2).join(" ").titleize }
    address { Faker::Address.full_address }
  end
end
