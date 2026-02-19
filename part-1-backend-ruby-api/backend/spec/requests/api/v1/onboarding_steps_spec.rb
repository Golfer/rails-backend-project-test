# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::OnboardingSteps", type: :request do
  def base_path
    "/api/v1/onboarding_steps"
  end

  describe "GET /api/v1/onboarding_steps" do
    it "returns a list of onboarding steps" do
      create_list(:onboarding_step, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to include(
        "id", "title", "slug", "sort_order", "category", "is_active", "is_mandatory"
      )
    end
  end

  describe "GET /api/v1/onboarding_steps/:id" do
    it "returns the step" do
      step = create(:onboarding_step, title: "Set forecasting days")
      api_get("#{base_path}/#{step.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(step.id)
      expect(json_response["title"]).to eq("Set forecasting days")
    end

    it "returns 404 for unknown id" do
      api_get("#{base_path}/99999")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/onboarding_steps" do
    it "creates an onboarding step" do
      params = {
        onboarding_step: {
          title: "Forecasting days",
          slug: "forecasting_days",
          sort_order: 1,
          category: "setup",
          is_active: true,
          is_mandatory: true
        }
      }
      expect { api_post(base_path, params) }.to change(OnboardingStep, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["title"]).to eq("Forecasting days")
      expect(json_response["slug"]).to eq("forecasting_days")
    end

    it "returns 422 when required attributes are missing" do
      api_post(base_path, { onboarding_step: { title: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/onboarding_steps/:id" do
    it "updates the step" do
      step = create(:onboarding_step, is_active: false)
      api_put("#{base_path}/#{step.id}", { onboarding_step: { is_active: true } })
      expect(response).to have_http_status(:ok)
      expect(json_response["is_active"]).to be(true)
      expect(step.reload.is_active).to be(true)
    end
  end

  describe "DELETE /api/v1/onboarding_steps/:id" do
    it "destroys the step" do
      step = create(:onboarding_step)
      expect { api_delete("#{base_path}/#{step.id}") }.to change(OnboardingStep, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
