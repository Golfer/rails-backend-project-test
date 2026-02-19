# frozen_string_literal: true

class Product < ApplicationRecord
  self.primary_key = :sku_id

  belongs_to :company
  belongs_to :vendor
  has_many :sales_history_records, class_name: "SalesHistory", foreign_key: :product_sku

  validates :sku_id, :name, presence: true
end
