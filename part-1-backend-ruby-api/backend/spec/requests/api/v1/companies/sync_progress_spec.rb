# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Companies::SyncProgress", type: :request do
  def show_path(company)
    "/api/v1/companies/#{company.id}/sync_progress"
  end

  describe "GET /api/v1/companies/:company_id/sync_progress" do
    it "returns aggregated sync progress for the company" do
      company = create(:company)
      create(:sync_status, company: company, entity_type: "Product", total_count: 100, synced_count: 40, is_finished: false)
      create(:sync_status, company: company, entity_type: "Warehouse", total_count: 5, synced_count: 5, is_finished: true)

      api_get(show_path(company))

      expect(response).to have_http_status(:ok)
      syncs = json_response["syncs"]
      expect(syncs).to be_an(Array).and have_attributes(size: 2)
      expect(syncs.find { |s| s["entity_type"] == "Product" }).to include("total_count" => 100, "synced_count" => 40, "is_finished" => false)
      expect(syncs.find { |s| s["entity_type"] == "Warehouse" }).to include("is_finished" => true)
    end

    it "returns 404 when company does not exist" do
      api_get("/api/v1/companies/#{SecureRandom.uuid}/sync_progress")
      expect(response).to have_http_status(:not_found)
    end
  end
end
