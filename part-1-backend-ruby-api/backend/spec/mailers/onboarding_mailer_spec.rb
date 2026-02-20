# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnboardingMailer, type: :mailer do
  describe "#step_completed_notification" do
    let(:company) { create(:company, name: "Acme") }
    let(:step) { create(:onboarding_step, title: "Set lead time") }
    let(:submission) { create(:onboarding_step_submission, company: company, step: step, status: "completed") }

    context "when company has users" do
      before { create(:user, company: company, email: "admin@example.com") }

      it "sends an email with step and company info" do
        mail = described_class.step_completed_notification(company, step, submission)

        expect(mail.to).to include("admin@example.com")
        expect(mail.subject).to include("Set lead time")
        expect(mail.subject).to include("Acme")
        expect(mail.body.encoded).to include("Set lead time")
        expect(mail.body.encoded).to include("Acme")
      end
    end

    context "when company has no users" do
      it "builds a message with no recipients so the worker can skip delivery" do
        company_without_users = create(:company)
        step2 = create(:onboarding_step, title: "Other")
        submission2 = create(:onboarding_step_submission, company: company_without_users, step: step2, status: "completed")

        mail = described_class.step_completed_notification(company_without_users, step2, submission2)

        # Mailer may return MessageDelivery; when no recipients, message has no "to" or we return nil
        expect(mail.nil? || mail.message.to.blank?).to be(true)
      end
    end
  end
end
