# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Companies", type: :request do
  def base_path
    "/api/v1/companies"
  end

  describe "GET /api/v1/companies" do
    it "returns a list of companies" do
      create_list(:company, 3)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(3)
      expect(json_response.first).to include("id", "name", "created_at")
    end

    it "returns empty array when no companies" do
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to eq([])
    end
  end

  describe "GET /api/v1/companies/:id" do
    it "returns the company" do
      company = create(:company)
      api_get("#{base_path}/#{company.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(company.id)
      expect(json_response["name"]).to eq(company.name)
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/companies" do
    it "creates a company" do
      params = { company: { name: "Acme Corp" } }
      expect { api_post(base_path, params) }.to change(Company, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["name"]).to eq("Acme Corp")
      expect(json_response["id"]).to be_present
    end

    it "returns 422 when name is blank" do
      api_post(base_path, { company: { name: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/companies/:id" do
    it "updates the company" do
      company = create(:company, name: "Old Name")
      api_put("#{base_path}/#{company.id}", { company: { name: "New Name" } })
      expect(response).to have_http_status(:ok)
      expect(json_response["name"]).to eq("New Name")
      expect(company.reload.name).to eq("New Name")
    end

    it "returns 422 when name is blank" do
      company = create(:company)
      api_put("#{base_path}/#{company.id}", { company: { name: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "DELETE /api/v1/companies/:id" do
    it "destroys the company" do
      company = create(:company)
      expect { api_delete("#{base_path}/#{company.id}") }.to change(Company, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it_behaves_like "returns 404 for unknown UUID on DELETE"
  end
end
