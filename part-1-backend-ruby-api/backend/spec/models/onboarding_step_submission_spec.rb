# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingStepSubmission, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:step).class_name("OnboardingStep") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).in_array(%w[started completed skipped]) }
  end

  describe "factory" do
    it "builds a valid submission" do
      submission = build(:onboarding_step_submission)
      expect(submission).to be_valid
    end

    it "enforces unique company_id + step_id" do
      company = create(:company)
      step = create(:onboarding_step)
      create(:onboarding_step_submission, company: company, step: step)
      duplicate = build(:onboarding_step_submission, company: company, step: step)
      expect(duplicate).not_to be_valid
    end
  end

  describe "completion side effects" do
    it "enqueues OnboardingStepCompletedWorker when status transitions to completed" do
      submission = create(:onboarding_step_submission, status: "started")
      allow(OnboardingStepCompletedWorker).to receive(:perform_async).and_return("jid")

      submission.update!(status: "completed")

      expect(OnboardingStepCompletedWorker).to have_received(:perform_async).with(submission.id)
    end

    it "does not enqueue when status is updated but not to completed" do
      submission = create(:onboarding_step_submission, status: "started")
      allow(OnboardingStepCompletedWorker).to receive(:perform_async)

      submission.update!(status: "skipped")

      expect(OnboardingStepCompletedWorker).not_to have_received(:perform_async)
    end
  end
end
