# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.string :email, null: false
      t.string :role, null: false # 'admin', 'planner'
    end

    add_index :users, [:company_id, :email], unique: true
  end
end
