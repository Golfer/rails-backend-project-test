# frozen_string_literal: true

class RefreshCalculationsWorker
  include Sidekiq::Job

  def perform(product_sku_id = nil)
    scope = product_sku_id ? Product.where(sku_id: product_sku_id) : Product.all
    scope.find_each do |product|
      refresh_forecasting_days(product)
    end
  end

  private

  def refresh_forecasting_days(product)
    # Placeholder: update forecasting_days from onboarding or other business logic
    product.update_column(:forecasting_days, product.forecasting_days) if product.forecasting_days.present?
  end
end
