# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Warehouses", type: :request do
  def base_path
    "/api/v1/warehouses"
  end

  describe "GET /api/v1/warehouses" do
    it "returns a list of warehouses" do
      create_list(:warehouse, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:warehouse, company: company)
      create(:warehouse)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
    end
  end

  describe "GET /api/v1/warehouses/:id" do
    it "returns the warehouse" do
      warehouse = create(:warehouse, name: "Main Warehouse")
      api_get("#{base_path}/#{warehouse.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(warehouse.id)
      expect(json_response["name"]).to eq("Main Warehouse")
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/warehouses" do
    it "creates a warehouse" do
      company = create(:company)
      params = { warehouse: { company_id: company.id, name: "New Warehouse", address: "123 Main St" } }
      expect { api_post(base_path, params) }.to change(Warehouse, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["name"]).to eq("New Warehouse")
      expect(json_response["address"]).to eq("123 Main St")
    end

    it "returns 422 when name is blank" do
      company = create(:company)
      api_post(base_path, { warehouse: { company_id: company.id, name: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/warehouses/:id" do
    it "updates the warehouse" do
      warehouse = create(:warehouse)
      api_put("#{base_path}/#{warehouse.id}", { warehouse: { address: "456 New Ave" } })
      expect(response).to have_http_status(:ok)
      expect(json_response["address"]).to eq("456 New Ave")
      expect(warehouse.reload.address).to eq("456 New Ave")
    end
  end

  describe "DELETE /api/v1/warehouses/:id" do
    it "destroys the warehouse" do
      warehouse = create(:warehouse)
      expect { api_delete("#{base_path}/#{warehouse.id}") }.to change(Warehouse, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
