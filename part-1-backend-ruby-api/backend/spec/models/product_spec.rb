# frozen_string_literal: true

require "rails_helper"

RSpec.describe Product, type: :model do
  describe "primary key" do
    it "uses sku_id as primary key" do
      expect(described_class.primary_key).to eq("sku_id")
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:vendor) }
    it { is_expected.to have_many(:sales_history_records).class_name("SalesHistory").with_foreign_key(:product_sku) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:sku_id) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "factory" do
    it "builds a valid product" do
      product = build(:product)
      expect(product).to be_valid
    end

    it "creates with sku_id" do
      product = create(:product, sku_id: "SKU-123")
      expect(product.sku_id).to eq("SKU-123")
    end
  end
end
