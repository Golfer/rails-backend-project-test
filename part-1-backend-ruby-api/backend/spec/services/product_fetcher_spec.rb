# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductFetcher do
  let(:company) { create(:company) }

  describe "#progress" do
    it "returns total and fetched from sync_status when Product sync exists" do
      create(:sync_status, company: company, entity_type: "Product", total_count: 50, synced_count: 30)

      result = described_class.new(company).progress

      expect(result).to eq(total: 50, fetched: 30)
    end

    it "returns zero counts when no Product sync_status exists" do
      result = described_class.new(company).progress

      expect(result).to eq(total: 0, fetched: 0)
    end
  end
end
