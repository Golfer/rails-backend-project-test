# frozen_string_literal: true

class OnboardingProcess < ApplicationRecord
  belongs_to :company
  belongs_to :current_step, class_name: "OnboardingStep", optional: true
end
