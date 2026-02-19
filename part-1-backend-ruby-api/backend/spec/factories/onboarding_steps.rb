# frozen_string_literal: true

FactoryBot.define do
  factory :onboarding_step do
    sequence(:title) { |n| "Step #{n}: #{Faker::Lorem.words(number: 2).join(' ')}" }
    sequence(:slug) { |n| "step_#{n}_#{Faker::Lorem.word}" }
    sort_order { 0 }
    category { %w[setup forecasting inventory].sample }
    is_active { true }
    is_mandatory { true }
    dependency_step { nil }

    trait :with_dependency do
      association :dependency_step, factory: :onboarding_step
    end
  end
end
