# frozen_string_literal: true

class CreateOnboardingStepSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :onboarding_step_submissions, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :step, null: false, foreign_key: { to_table: :onboarding_steps }
      t.string :status, null: false # 'started', 'completed', 'skipped'
      t.jsonb :values, default: {}
      t.timestamp :completed_at
      t.timestamps
    end

    add_index :onboarding_step_submissions, [:company_id, :step_id], unique: true
  end
end
