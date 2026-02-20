# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingStepCompletedWorker, type: :worker do
  describe "#perform" do
    it "runs the completion handler and sends notification when submission is completed" do
      company = create(:company)
      step = create(:onboarding_step, slug: "lead_time")
      submission = create(:onboarding_step_submission, company: company, step: step, status: "completed")
      allow(OnboardingStepCompletionHandler).to receive(:run)
      allow(OnboardingMailer).to receive(:step_completed_notification).and_return(double(deliver_later: true))

      described_class.new.perform(submission.id)

      expect(OnboardingStepCompletionHandler).to have_received(:run).with(company, step, an_object_having_attributes(id: submission.id))
      expect(OnboardingMailer).to have_received(:step_completed_notification).with(company, step, an_object_having_attributes(id: submission.id))
    end

    it "does nothing when submission is not found" do
      allow(OnboardingStepCompletionHandler).to receive(:run)
      allow(OnboardingMailer).to receive(:step_completed_notification)

      described_class.new.perform(SecureRandom.uuid)

      expect(OnboardingStepCompletionHandler).not_to have_received(:run)
      expect(OnboardingMailer).not_to have_received(:step_completed_notification)
    end

    it "does not run handler or send mail when submission status is not completed" do
      company = create(:company)
      step = create(:onboarding_step, slug: "lead_time")
      submission = create(:onboarding_step_submission, company: company, step: step, status: "started")
      allow(OnboardingStepCompletionHandler).to receive(:run)
      allow(OnboardingMailer).to receive(:step_completed_notification)

      described_class.new.perform(submission.id)

      expect(OnboardingStepCompletionHandler).not_to have_received(:run)
      expect(OnboardingMailer).not_to have_received(:step_completed_notification)
    end

    it "does not send mail when company has no users" do
      company = create(:company)
      step = create(:onboarding_step, slug: "lead_time")
      submission = create(:onboarding_step_submission, company: company, step: step, status: "completed")
      allow(OnboardingStepCompletionHandler).to receive(:run)
      allow(OnboardingMailer).to receive(:step_completed_notification).and_return(nil)

      described_class.new.perform(submission.id)

      expect(OnboardingStepCompletionHandler).to have_received(:run).with(company, step, an_object_having_attributes(id: submission.id))
      expect(OnboardingMailer).to have_received(:step_completed_notification).with(company, step, an_object_having_attributes(id: submission.id))
    end
  end
end
