# frozen_string_literal: true

class OnboardingStepCompletionHandler
  HANDLERS = {
    "lead_time" => ->(company, submission) { LeadTimeUpdater.new(company, submission.values).call },
    "forecasting_days" => ->(company, _submission) { RefreshCalculationsWorker.perform_async },
    "forecasting_window" => ->(company, _submission) { RefreshCalculationsWorker.perform_async }
  }.freeze

  def self.run(company, step, submission)
    handler = HANDLERS[step.slug]
    return unless handler

    handler.call(company, submission)
  end
end
