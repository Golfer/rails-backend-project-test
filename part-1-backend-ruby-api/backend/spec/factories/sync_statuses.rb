# frozen_string_literal: true

FactoryBot.define do
  factory :sync_status do
    association :company
    entity_type { %w[Warehouse Product SalesHistory].sample }
    total_count { 0 }
    synced_count { 0 }
    is_finished { false }

    trait :finished do
      total_count { 100 }
      synced_count { 100 }
      is_finished { true }
    end
  end
end
