# frozen_string_literal: true

class OnboardingMailer < ApplicationMailer
  # Sent after the onboarding step completion worker has run (side effects applied).
  # Returns a Mail::Message when recipients exist, nil otherwise.
  def step_completed_notification(company, step, submission)
    @company = company
    @step = step
    @submission = submission

    to = recipient_emails(company)
    return nil if to.empty?

    mail(
      to: to,
      subject: I18n.t("onboarding_mailer.step_completed_notification.subject", step_title: step.title, company_name: company.name)
    )
  end

  private

  def recipient_emails(company)
    company.users.limit(10).pluck(:email).compact_blank
  end
end
