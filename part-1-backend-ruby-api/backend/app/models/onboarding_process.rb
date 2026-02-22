# frozen_string_literal: true

class OnboardingProcess < ApplicationRecord
  belongs_to :company
  belongs_to :current_step, class_name: "OnboardingStep", optional: true

  validate :current_step_must_exist, if: :current_step_id?

  private

  def current_step_must_exist
    return if current_step_id.blank?

    unless OnboardingStep.exists?(current_step_id)
      errors.add(:current_step_id, "must reference an existing onboarding step")
    end
  end
end
