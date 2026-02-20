# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefreshCalculationsWorker, type: :worker do
  describe "#perform" do
    it "runs without error when no argument" do
      expect { described_class.new.perform }.not_to raise_error
    end

    it "runs without error when product sku_id is given" do
      product = create(:product, sku_id: "SKU-REFRESH")
      expect { described_class.new.perform(product.sku_id) }.not_to raise_error
    end

    it "processes all products when no argument" do
      create_list(:product, 2)
      expect { described_class.new.perform }.not_to raise_error
    end

    it "processes only the product matching sku_id when argument given" do
      product_one = create(:product, sku_id: "SKU-ONE", forecasting_days: 60)
      create(:product, sku_id: "SKU-TWO", forecasting_days: 90)
      scope = instance_double(ActiveRecord::Relation)
      allow(scope).to receive(:find_each).and_yield(product_one)
      allow(Product).to receive(:where).with(sku_id: "SKU-ONE").and_return(scope)
      allow(product_one).to receive(:update_column)

      described_class.new.perform("SKU-ONE")

      expect(product_one).to have_received(:update_column).with(:forecasting_days, 60)
    end
  end
end
