# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingProcess, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:current_step).class_name("OnboardingStep").optional }
  end

  describe "factory" do
    it "builds a valid process" do
      process_record = build(:onboarding_process)
      expect(process_record).to be_valid
    end

    it "can have a current_step" do
      process_record = create(:onboarding_process, :with_step)
      expect(process_record.current_step_id).to be_present
    end
  end
end
