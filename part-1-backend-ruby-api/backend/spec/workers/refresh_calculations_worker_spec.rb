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
  end
end
