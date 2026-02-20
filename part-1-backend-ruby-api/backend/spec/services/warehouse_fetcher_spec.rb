# frozen_string_literal: true

require "rails_helper"

RSpec.describe WarehouseFetcher do
  let(:company) { create(:company) }

  describe "#progress" do
    it "returns total and fetched from sync_status when Warehouse sync exists" do
      create(:sync_status, company: company, entity_type: "Warehouse", total_count: 10, synced_count: 8)

      result = described_class.new(company).progress

      expect(result).to eq(total: 10, fetched: 8)
    end

    it "returns zero counts when no Warehouse sync_status exists" do
      result = described_class.new(company).progress

      expect(result).to eq(total: 0, fetched: 0)
    end
  end
end
