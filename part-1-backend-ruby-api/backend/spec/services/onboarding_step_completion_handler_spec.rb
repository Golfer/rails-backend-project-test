# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingStepCompletionHandler do
  let(:company) { create(:company) }

  describe ".run" do
    context "when step has a registered handler" do
      it "invokes the lead_time handler with company and submission values" do
        step = create(:onboarding_step, slug: "lead_time")
        submission = build(:onboarding_step_submission, company: company, step: step, values: { lead_time_days: 7 })
        updater = instance_double(LeadTimeUpdater, call: true)
        allow(LeadTimeUpdater).to receive(:new).and_return(updater)

        described_class.run(company, step, submission)

        expect(LeadTimeUpdater).to have_received(:new).with(company, submission.values)
        expect(updater).to have_received(:call)
      end

      it "invokes RefreshCalculationsWorker for forecasting_days step" do
        step = create(:onboarding_step, slug: "forecasting_days")
        submission = build(:onboarding_step_submission, company: company, step: step)

        allow(RefreshCalculationsWorker).to receive(:perform_async)

        described_class.run(company, step, submission)

        expect(RefreshCalculationsWorker).to have_received(:perform_async)
      end

      it "invokes RefreshCalculationsWorker for forecasting_window step" do
        step = create(:onboarding_step, slug: "forecasting_window")
        submission = build(:onboarding_step_submission, company: company, step: step)

        allow(RefreshCalculationsWorker).to receive(:perform_async)

        described_class.run(company, step, submission)

        expect(RefreshCalculationsWorker).to have_received(:perform_async)
      end
    end

    context "when step has no handler" do
      it "does nothing" do
        step = create(:onboarding_step, slug: "unknown_step")
        submission = build(:onboarding_step_submission, company: company, step: step)
        allow(LeadTimeUpdater).to receive(:new)
        allow(RefreshCalculationsWorker).to receive(:perform_async)

        described_class.run(company, step, submission)

        expect(LeadTimeUpdater).not_to have_received(:new)
        expect(RefreshCalculationsWorker).not_to have_received(:perform_async)
      end
    end
  end
end
