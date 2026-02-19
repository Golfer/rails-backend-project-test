# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  def base_path
    "/api/v1/users"
  end

  describe "GET /api/v1/users" do
    it "returns a list of users" do
      create_list(:user, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to include("id", "company_id", "email", "role")
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:user, company: company)
      create(:user)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["company_id"]).to eq(company.id)
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns the user" do
      user = create(:user, email: "admin@example.com", role: "admin")
      api_get("#{base_path}/#{user.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(user.id)
      expect(json_response["email"]).to eq("admin@example.com")
      expect(json_response["role"]).to eq("admin")
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/users" do
    it "creates a user" do
      company = create(:company)
      params = { user: { company_id: company.id, email: "planner@example.com", role: "planner" } }
      expect { api_post(base_path, params) }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["email"]).to eq("planner@example.com")
      expect(json_response["role"]).to eq("planner")
    end

    it "returns 422 when email is blank" do
      company = create(:company)
      api_post(base_path, { user: { company_id: company.id, email: "", role: "admin" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end

    it "returns 422 when email is duplicate within company" do
      company = create(:company)
      create(:user, company: company, email: "same@example.com")
      api_post(base_path, { user: { company_id: company.id, email: "same@example.com", role: "planner" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/users/:id" do
    it "updates the user" do
      user = create(:user, role: "planner")
      api_put("#{base_path}/#{user.id}", { user: { role: "admin" } })
      expect(response).to have_http_status(:ok)
      expect(json_response["role"]).to eq("admin")
      expect(user.reload.role).to eq("admin")
    end
  end

  describe "DELETE /api/v1/users/:id" do
    it "destroys the user" do
      user = create(:user)
      expect { api_delete("#{base_path}/#{user.id}") }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
