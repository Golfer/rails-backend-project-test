# frozen_string_literal: true

FactoryBot.define do
  factory :onboarding_process do
    association :company
    current_step { nil }

    trait :with_step do
      association :current_step, factory: :onboarding_step
    end
  end
end
