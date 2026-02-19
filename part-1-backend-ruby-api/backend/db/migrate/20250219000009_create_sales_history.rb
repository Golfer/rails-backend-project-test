# frozen_string_literal: true

class CreateSalesHistory < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_history, id: :uuid do |t|
      t.string :product_sku, null: false
      t.date :sale_date, null: false
      t.integer :quantity, null: false
    end

    add_foreign_key :sales_history, :products, column: :product_sku, primary_key: :sku_id
    add_index :sales_history, [:product_sku, :sale_date]
  end
end
