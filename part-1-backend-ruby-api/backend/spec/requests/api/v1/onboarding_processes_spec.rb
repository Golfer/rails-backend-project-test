# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::OnboardingProcesses", type: :request do
  def base_path
    "/api/v1/onboarding_processes"
  end

  describe "GET /api/v1/onboarding_processes" do
    it "returns a list of onboarding processes" do
      create_list(:onboarding_process, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:onboarding_process, company: company)
      create(:onboarding_process)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["company_id"]).to eq(company.id)
    end
  end

  describe "GET /api/v1/onboarding_processes/:id" do
    it "returns the process" do
      process_record = create(:onboarding_process)
      api_get("#{base_path}/#{process_record.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(process_record.id)
      expect(json_response["company_id"]).to eq(process_record.company_id)
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/onboarding_processes" do
    it "creates an onboarding process" do
      company = create(:company)
      step = create(:onboarding_step)
      params = { onboarding_process: { company_id: company.id, current_step_id: step.id } }
      expect { api_post(base_path, params) }.to change(OnboardingProcess, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["company_id"]).to eq(company.id)
      expect(json_response["current_step_id"]).to eq(step.id)
    end

    it "returns 422 when company_id is missing" do
      api_post(base_path, { onboarding_process: { company_id: nil } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/onboarding_processes/:id" do
    it "updates the process" do
      process_record = create(:onboarding_process, current_step: nil)
      step = create(:onboarding_step)
      api_put("#{base_path}/#{process_record.id}", { onboarding_process: { current_step_id: step.id } })
      expect(response).to have_http_status(:ok)
      expect(json_response["current_step_id"]).to eq(step.id)
      expect(process_record.reload.current_step_id).to eq(step.id)
    end
  end

  describe "DELETE /api/v1/onboarding_processes/:id" do
    it "destroys the process" do
      process_record = create(:onboarding_process)
      expect { api_delete("#{base_path}/#{process_record.id}") }.to change(OnboardingProcess, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
