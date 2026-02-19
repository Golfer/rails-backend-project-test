# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::SyncStatuses", type: :request do
  def base_path
    "/api/v1/sync_statuses"
  end

  describe "GET /api/v1/sync_statuses" do
    it "returns a list of sync statuses" do
      create_list(:sync_status, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to include(
        "id", "company_id", "entity_type", "total_count", "synced_count", "is_finished"
      )
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:sync_status, company: company)
      create(:sync_status)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["company_id"]).to eq(company.id)
    end
  end

  describe "GET /api/v1/sync_statuses/:id" do
    it "returns the sync status" do
      sync_status = create(:sync_status, entity_type: "Product", is_finished: true)
      api_get("#{base_path}/#{sync_status.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(sync_status.id)
      expect(json_response["entity_type"]).to eq("Product")
      expect(json_response["is_finished"]).to be(true)
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/sync_statuses" do
    it "creates a sync status" do
      company = create(:company)
      params = {
        sync_status: {
          company_id: company.id,
          entity_type: "Warehouse",
          total_count: 50,
          synced_count: 0,
          is_finished: false
        }
      }
      expect { api_post(base_path, params) }.to change(SyncStatus, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["entity_type"]).to eq("Warehouse")
      expect(json_response["total_count"]).to eq(50)
    end

    it "returns 422 when entity_type is blank" do
      company = create(:company)
      api_post(base_path, { sync_status: { company_id: company.id, entity_type: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/sync_statuses/:id" do
    it "updates the sync status" do
      sync_status = create(:sync_status, synced_count: 0, is_finished: false)
      api_put("#{base_path}/#{sync_status.id}", { sync_status: { synced_count: 100, is_finished: true } })
      expect(response).to have_http_status(:ok)
      expect(json_response["synced_count"]).to eq(100)
      expect(json_response["is_finished"]).to be(true)
      expect(sync_status.reload.is_finished).to be(true)
    end
  end

  describe "DELETE /api/v1/sync_statuses/:id" do
    it "destroys the sync status" do
      sync_status = create(:sync_status)
      expect { api_delete("#{base_path}/#{sync_status.id}") }.to change(SyncStatus, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
