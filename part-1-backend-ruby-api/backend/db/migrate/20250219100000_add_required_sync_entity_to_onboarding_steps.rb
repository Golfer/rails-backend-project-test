# frozen_string_literal: true

class AddRequiredSyncEntityToOnboardingSteps < ActiveRecord::Migration[8.0]
  def change
    add_column :onboarding_steps, :required_sync_entity, :string
  end
end
