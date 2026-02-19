# frozen_string_literal: true

class SalesHistory < ApplicationRecord
  self.table_name = "sales_history"

  belongs_to :product, foreign_key: :product_sku, primary_key: :sku_id

  validates :product_sku, :sale_date, :quantity, presence: true
end
