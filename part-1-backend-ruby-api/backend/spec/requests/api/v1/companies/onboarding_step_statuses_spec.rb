# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Companies::OnboardingStepStatuses", type: :request do
  def index_path(company)
    "/api/v1/companies/#{company.id}/onboarding_step_statuses"
  end

  describe "GET /api/v1/companies/:company_id/onboarding_step_statuses" do
    it "returns all onboarding steps ordered by sort_order" do
      company = create(:company)
      first = create(:onboarding_step, sort_order: 1, title: "First")
      second = create(:onboarding_step, sort_order: 2, title: "Second")

      api_get(index_path(company))

      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array).and have_attributes(size: 2)
      expect(json_response.map { |s| s["title"] }).to eq(%w[First Second])
    end

    it "returns 404 when company does not exist" do
      api_get("/api/v1/companies/#{SecureRandom.uuid}/onboarding_step_statuses")
      expect(response).to have_http_status(:not_found)
    end
  end
end
