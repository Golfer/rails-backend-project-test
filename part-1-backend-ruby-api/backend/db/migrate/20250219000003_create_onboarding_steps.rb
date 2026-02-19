# frozen_string_literal: true

class CreateOnboardingSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :onboarding_steps do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.integer :sort_order, null: false
      t.string :category
      t.boolean :is_active, default: false, null: false
      t.boolean :is_mandatory, default: true, null: false
      t.references :dependency_step, foreign_key: { to_table: :onboarding_steps }, index: true
    end

    add_index :onboarding_steps, :slug, unique: true
  end
end
