# frozen_string_literal: true

class OnboardingStepCompletedWorker
  include Sidekiq::Job

  sidekiq_options queue: :default, retry: 3

  def perform(submission_id)
    submission = OnboardingStepSubmission.find_by(id: submission_id)
    return unless submission
    return unless submission.status == "completed"

    company = submission.company
    step = submission.step

    run_side_effects(company, step, submission)
    notify_changes_applied(company, step, submission)
  end

  private

  def run_side_effects(company, step, submission)
    OnboardingStepCompletionHandler.run(company, step, submission)
  end

  def notify_changes_applied(company, step, submission)
    message = OnboardingMailer.step_completed_notification(company, step, submission)
    return if message.blank?
    return if message.respond_to?(:message) && message.message&.to&.blank?

    message.deliver_later
  end
end
