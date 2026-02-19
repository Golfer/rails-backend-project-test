# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingStep, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:dependency_step).class_name("OnboardingStep").optional }
    it { is_expected.to have_many(:dependent_steps).class_name("OnboardingStep").with_foreign_key(:dependency_step_id) }
    it { is_expected.to have_many(:onboarding_processes).with_foreign_key(:current_step_id) }
    it { is_expected.to have_many(:onboarding_step_submissions).with_foreign_key(:step_id) }
  end

  describe "validations" do
    subject { create(:onboarding_step) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:sort_order) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end

  describe "factory" do
    it "builds a valid step" do
      step = build(:onboarding_step)
      expect(step).to be_valid
    end

    it "supports dependency_step" do
      parent = create(:onboarding_step)
      child = create(:onboarding_step, dependency_step: parent)
      expect(child.dependency_step_id).to eq(parent.id)
    end
  end
end
