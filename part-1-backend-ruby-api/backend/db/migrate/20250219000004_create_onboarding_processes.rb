# frozen_string_literal: true

class CreateOnboardingProcesses < ActiveRecord::Migration[8.0]
  def change
    create_table :onboarding_processes, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :current_step, foreign_key: { to_table: :onboarding_steps }, index: true
    end
  end
end
