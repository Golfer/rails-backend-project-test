# frozen_string_literal: true

class OnboardingStep < ApplicationRecord
  belongs_to :dependency_step, class_name: "OnboardingStep", optional: true
  has_many :dependent_steps, class_name: "OnboardingStep", foreign_key: :dependency_step_id
  has_many :onboarding_processes, foreign_key: :current_step_id
  has_many :onboarding_step_submissions, foreign_key: :step_id

  validates :title, :slug, :sort_order, presence: true
  validates :slug, uniqueness: true
end
