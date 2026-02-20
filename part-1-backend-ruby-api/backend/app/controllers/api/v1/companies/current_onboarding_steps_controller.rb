# frozen_string_literal: true

module Api
  module V1
    module Companies
      class CurrentOnboardingStepsController < Api::V1::BaseController
        before_action :set_company

        # GET /api/v1/companies/:company_id/current_onboarding_step
        # Returns the step the user should see so they can resume where they left off.
        def show
          process = find_or_create_process
          return render json: { message: "No onboarding steps defined" }, status: :not_found unless process

          step = process.current_step
          return render json: { message: "No onboarding steps defined" }, status: :not_found unless step

          render json: step
        end

        private

        def set_company
          @company = Company.find(params[:company_id])
        end

        def find_or_create_process
          return nil unless OnboardingStep.any?

          process = @company.onboarding_processes.order(id: :desc).first
          first_step = OnboardingStep.order(:sort_order).first

          if process.nil?
            process = @company.onboarding_processes.create!(current_step_id: first_step.id)
          elsif process.current_step_id.nil?
            process.update!(current_step_id: first_step.id)
          end

          process
        end
      end
    end
  end
end
