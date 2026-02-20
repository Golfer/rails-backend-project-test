# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    it "creates a user and returns user + token" do
      company = create(:company)
      params = {
        user: {
          company_id: company.id,
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "planner"
        }
      }

      expect { post request_url("/api/v1/auth/register"), params: params.to_json, headers: api_headers }
        .to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response["user"]["email"]).to eq("new@example.com")
      expect(json_response["token"]).to be_present
    end

    it "returns 422 when password too short" do
      company = create(:company)
      params = { user: { company_id: company.id, email: "a@b.com", password: "short", password_confirmation: "short", role: "planner" } }

      post request_url("/api/v1/auth/register"), params: params.to_json, headers: api_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "POST /api/v1/auth/login" do
    it "returns user + token for valid email/password" do
      create(:user, email: "login@example.com", password: "secret123", password_confirmation: "secret123")

      post request_url("/api/v1/auth/login"), params: { email: "login@example.com", password: "secret123" }.to_json, headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_response["user"]["email"]).to eq("login@example.com")
      expect(json_response["token"]).to be_present
    end

    it "returns 401 for wrong password" do
      create(:user, email: "u@example.com", password: "rightpass", password_confirmation: "rightpass")

      post request_url("/api/v1/auth/login"), params: { email: "u@example.com", password: "wrong" }.to_json, headers: api_headers

      expect(response).to have_http_status(:unauthorized)
      expect(json_response["error"]).to eq("Invalid email or password")
    end
  end

  describe "GET /api/v1/auth/me" do
    it "returns current user when authenticated" do
      user = create(:user, email: "me@example.com", password: "password123", password_confirmation: "password123")

      get request_url("/api/v1/auth/me"), headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["email"]).to eq("me@example.com")
    end

    it "returns 401 when no token" do
      get request_url("/api/v1/auth/me"), headers: api_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
