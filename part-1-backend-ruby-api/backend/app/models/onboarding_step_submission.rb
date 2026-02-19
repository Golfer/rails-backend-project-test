# frozen_string_literal: true

class OnboardingStepSubmission < ApplicationRecord
  belongs_to :company
  belongs_to :step, class_name: "OnboardingStep"

  validates :status, presence: true, inclusion: { in: %w[started completed skipped] }
  validates :step_id, uniqueness: { scope: :company_id }
end
