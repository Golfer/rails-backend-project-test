# frozen_string_literal: true

class OnboardingStepSubmission < ApplicationRecord
  belongs_to :company
  belongs_to :step, class_name: "OnboardingStep"

  validates :status, presence: true, inclusion: { in: %w[started completed skipped] }
  validates :step_id, uniqueness: { scope: :company_id }

  after_save :mark_just_completed_if_transitioned
  after_commit :enqueue_completion_worker, on: [ :create, :update ]

  private

  def mark_just_completed_if_transitioned
    @just_completed = (status == "completed" && saved_change_to_status?)
  end

  def enqueue_completion_worker
    return unless instance_variable_defined?(:@just_completed) && @just_completed

    OnboardingStepCompletedWorker.perform_async(id)
  end
end
