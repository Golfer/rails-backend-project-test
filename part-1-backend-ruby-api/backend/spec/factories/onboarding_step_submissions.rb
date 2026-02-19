# frozen_string_literal: true

FactoryBot.define do
  factory :onboarding_step_submission do
    association :company
    association :step, factory: :onboarding_step
    status { %w[started completed skipped].sample }
    values { {} }
    completed_at { status == "completed" ? Time.current : nil }

    trait :started do
      status { "started" }
      completed_at { nil }
    end

    trait :completed do
      status { "completed" }
      completed_at { Time.current }
      values { { "days" => 63 } }
    end

    trait :skipped do
      status { "skipped" }
      completed_at { nil }
    end
  end
end
