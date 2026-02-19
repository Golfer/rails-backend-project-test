# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncStatus, type: :model do
  describe "table name" do
    it "uses sync_status table" do
      expect(described_class.table_name).to eq("sync_status")
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:company) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:entity_type) }
  end

  describe "factory" do
    it "builds a valid sync status" do
      sync_status = build(:sync_status)
      expect(sync_status).to be_valid
    end

    it "supports finished trait" do
      sync_status = create(:sync_status, :finished)
      expect(sync_status.is_finished).to be(true)
      expect(sync_status.synced_count).to eq(sync_status.total_count)
    end
  end
end
