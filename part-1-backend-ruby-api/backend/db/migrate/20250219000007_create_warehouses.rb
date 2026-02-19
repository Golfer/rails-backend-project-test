# frozen_string_literal: true

class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.text :address
    end
  end
end
