# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:sku_id) { |n| "SKU-#{format('%06d', n)}" }
    association :company
    association :vendor
    name { Faker::Commerce.product_name }
    lead_time_days { rand(1..30) }
    days_of_stock { rand(7..90) }
    forecasting_days { rand(30..90) }
  end
end
