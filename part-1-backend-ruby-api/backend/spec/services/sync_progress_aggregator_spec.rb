# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncProgressAggregator do
  let(:company) { create(:company) }

  describe "#progress_list" do
    it "returns progress for Product and Warehouse using fetchers and sync_status is_finished" do
      create(:sync_status, company: company, entity_type: "Product", total_count: 100, synced_count: 100, is_finished: true)
      create(:sync_status, company: company, entity_type: "Warehouse", total_count: 5, synced_count: 2, is_finished: false)

      result = described_class.new(company).progress_list

      expect(result).to contain_exactly(
        { entity_type: "Product", total_count: 100, synced_count: 100, is_finished: true },
        { entity_type: "Warehouse", total_count: 5, synced_count: 2, is_finished: false }
      )
    end

    it "returns zero counts and is_finished false when sync_status is missing for an entity" do
      result = described_class.new(company).progress_list

      expect(result).to contain_exactly(
        { entity_type: "Product", total_count: 0, synced_count: 0, is_finished: false },
        { entity_type: "Warehouse", total_count: 0, synced_count: 0, is_finished: false }
      )
    end
  end
end
