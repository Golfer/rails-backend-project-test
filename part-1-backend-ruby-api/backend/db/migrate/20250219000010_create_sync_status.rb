# frozen_string_literal: true

class CreateSyncStatus < ActiveRecord::Migration[8.0]
  def change
    create_table :sync_status, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.string :entity_type, null: false # 'Warehouse', 'Product', 'SalesHistory'
      t.integer :total_count, default: 0
      t.integer :synced_count, default: 0
      t.boolean :is_finished, default: false, null: false
    end

    add_index :sync_status, [:company_id, :entity_type], unique: true
  end
end
