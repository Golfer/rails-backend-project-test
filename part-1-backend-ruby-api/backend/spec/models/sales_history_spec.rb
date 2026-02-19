# frozen_string_literal: true

require "rails_helper"

RSpec.describe SalesHistory, type: :model do
  describe "table name" do
    it "uses sales_history table" do
      expect(described_class.table_name).to eq("sales_history")
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:product).with_foreign_key(:product_sku).with_primary_key(:sku_id) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:product_sku) }
    it { is_expected.to validate_presence_of(:sale_date) }
    it { is_expected.to validate_presence_of(:quantity) }
  end

  describe "factory" do
    it "builds a valid record" do
      record = build(:sales_history)
      expect(record).to be_valid
    end

    it "associates with product via product_sku" do
      product = create(:product, sku_id: "SKU-X")
      record = create(:sales_history, product_sku: product.sku_id)
      expect(record.product).to eq(product)
    end
  end
end
