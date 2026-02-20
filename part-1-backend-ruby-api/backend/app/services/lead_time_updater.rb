# frozen_string_literal: true

# Updates product lead time (and related fields) when the user completes the lead time onboarding step.
class LeadTimeUpdater
  def initialize(company, values = {})
    @company = company
    @values = values
  end

  def call
    # Apply lead_time_days from values to company products (or a subset).
    # Placeholder: in a real app, parse values and update Product.lead_time_days etc.
    return unless @values.is_a?(Hash)

    lead_time = @values["lead_time_days"] || @values[:lead_time_days]
    return unless lead_time.is_a?(Integer)

    @company.products.update_all(lead_time_days: lead_time)
  end
end
