# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: false, if_not_exists: true do |t|
      t.string :sku_id, null: false
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :vendor, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.integer :lead_time_days
      t.integer :days_of_stock
      t.integer :forecasting_days
    end

    return if connection.primary_key("products").present?

    execute "ALTER TABLE products ADD PRIMARY KEY (sku_id)"
  end
end
