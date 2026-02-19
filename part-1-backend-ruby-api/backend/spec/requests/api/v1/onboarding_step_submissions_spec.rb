# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::OnboardingStepSubmissions", type: :request do
  def base_path
    "/api/v1/onboarding_step_submissions"
  end

  describe "GET /api/v1/onboarding_step_submissions" do
    it "returns a list of submissions" do
      create_list(:onboarding_step_submission, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:onboarding_step_submission, company: company)
      create(:onboarding_step_submission)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["company_id"]).to eq(company.id)
    end
  end

  describe "GET /api/v1/onboarding_step_submissions/:id" do
    it "returns the submission" do
      submission = create(:onboarding_step_submission, status: "completed")
      api_get("#{base_path}/#{submission.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(submission.id)
      expect(json_response["status"]).to eq("completed")
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/onboarding_step_submissions" do
    it "creates a submission" do
      company = create(:company)
      step = create(:onboarding_step)
      params = {
        onboarding_step_submission: {
          company_id: company.id,
          step_id: step.id,
          status: "started",
          values: { "days" => 63 }
        }
      }
      expect { api_post(base_path, params) }.to change(OnboardingStepSubmission, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["status"]).to eq("started")
      expect(json_response["values"]).to include("days" => 63)
    end

    it "returns 422 when status is invalid" do
      company = create(:company)
      step = create(:onboarding_step)
      params = {
        onboarding_step_submission: {
          company_id: company.id,
          step_id: step.id,
          status: "invalid"
        }
      }
      api_post(base_path, params)
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/onboarding_step_submissions/:id" do
    it "updates the submission" do
      submission = create(:onboarding_step_submission, :started)
      params = { onboarding_step_submission: { status: "completed", completed_at: Time.current.iso8601 } }
      api_put("#{base_path}/#{submission.id}", params)
      expect(response).to have_http_status(:ok)
      expect(json_response["status"]).to eq("completed")
      expect(submission.reload.status).to eq("completed")
    end
  end

  describe "DELETE /api/v1/onboarding_step_submissions/:id" do
    it "destroys the submission" do
      submission = create(:onboarding_step_submission)
      expect { api_delete("#{base_path}/#{submission.id}") }.to change(OnboardingStepSubmission, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
