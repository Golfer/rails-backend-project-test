# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Vendors", type: :request do
  def base_path
    "/api/v1/vendors"
  end

  describe "GET /api/v1/vendors" do
    it "returns a list of vendors" do
      create_list(:vendor, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:vendor, company: company)
      create(:vendor)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["company_id"]).to eq(company.id)
    end
  end

  describe "GET /api/v1/vendors/:id" do
    it "returns the vendor" do
      vendor = create(:vendor, name: "Vendor One")
      api_get("#{base_path}/#{vendor.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(vendor.id)
      expect(json_response["name"]).to eq("Vendor One")
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/vendors" do
    it "creates a vendor" do
      company = create(:company)
      params = { vendor: { company_id: company.id, name: "New Vendor", contact_info: { email: "v@example.com" } } }
      expect { api_post(base_path, params) }.to change(Vendor, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["name"]).to eq("New Vendor")
      expect(json_response["contact_info"]).to include("email" => "v@example.com")
    end

    it "returns 422 when name is blank" do
      company = create(:company)
      api_post(base_path, { vendor: { company_id: company.id, name: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/vendors/:id" do
    it "updates the vendor" do
      vendor = create(:vendor, name: "Old")
      api_put("#{base_path}/#{vendor.id}", { vendor: { name: "Updated Vendor" } })
      expect(response).to have_http_status(:ok)
      expect(json_response["name"]).to eq("Updated Vendor")
      expect(vendor.reload.name).to eq("Updated Vendor")
    end
  end

  describe "DELETE /api/v1/vendors/:id" do
    it "destroys the vendor" do
      vendor = create(:vendor)
      expect { api_delete("#{base_path}/#{vendor.id}") }.to change(Vendor, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
