# frozen_string_literal: true

module Api
  module V1
    module Companies
      # GET /api/v1/companies/:company_id/onboarding_step_statuses
      # Returns all onboarding steps for the company (e.g. for sidebar or progress).
      class OnboardingStepStatusesController < Api::V1::BaseController
        before_action :set_company

        def index
          steps = OnboardingStep.order(:sort_order)
          render json: steps
        end

        private

        def set_company
          @company = Company.find(params[:company_id])
        end
      end
    end
  end
end
