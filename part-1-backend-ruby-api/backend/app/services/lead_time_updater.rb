# frozen_string_literal: true

class LeadTimeUpdater
  def initialize(company, values = {})
    @company = company
    @values = values
  end

  def call
    return unless @values.is_a?(Hash)

    lead_time = @values[:lead_time_days]
    return unless lead_time.is_a?(Integer)

    @company.products.update_all(lead_time_days: lead_time)
  end
end
