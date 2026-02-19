# frozen_string_literal: true

class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.jsonb :contact_info, default: {}
    end
  end
end
