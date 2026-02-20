# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Companies::CurrentOnboardingSteps", type: :request do
  def show_path(company)
    "/api/v1/companies/#{company.id}/current_onboarding_step"
  end

  describe "GET /api/v1/companies/:company_id/current_onboarding_step" do
    it "returns the current step so the user can resume where they left off" do
      company = create(:company)
      step = create(:onboarding_step, title: "Set forecasting days", slug: "forecasting_days", sort_order: 1)
      create(:onboarding_process, company: company, current_step: step)

      api_get(show_path(company))

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(step.id)
      expect(json_response["title"]).to eq("Set forecasting days")
      expect(json_response["slug"]).to eq("forecasting_days")
    end

    it "creates an onboarding process and sets first step when company has none" do
      company = create(:company)
      first = create(:onboarding_step, sort_order: 1, title: "First")
      create(:onboarding_step, sort_order: 2, title: "Second")

      api_get(show_path(company))

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(first.id)
      expect(json_response["title"]).to eq("First")
      expect(company.onboarding_processes.count).to eq(1)
      expect(company.onboarding_processes.first.current_step_id).to eq(first.id)
    end

    it "returns 404 when company does not exist" do
      api_get("/api/v1/companies/#{SecureRandom.uuid}/current_onboarding_step")
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 when no onboarding steps are defined" do
      company = create(:company)

      api_get(show_path(company))

      expect(response).to have_http_status(:not_found)
      expect(json_response["message"]).to eq("No onboarding steps defined")
    end
  end
end
