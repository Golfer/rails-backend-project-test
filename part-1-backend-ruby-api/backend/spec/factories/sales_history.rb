# frozen_string_literal: true

FactoryBot.define do
  factory :sales_history do
    product_sku { create(:product).sku_id }
    sale_date { Faker::Date.between(from: 1.year.ago, to: Date.current) }
    quantity { rand(1..1000) }
  end
end
