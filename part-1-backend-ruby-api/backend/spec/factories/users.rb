# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :company
    email { Faker::Internet.unique.email }
    role { %w[admin planner].sample }
  end
end
