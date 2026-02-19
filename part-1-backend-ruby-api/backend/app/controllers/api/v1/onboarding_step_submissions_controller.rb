# frozen_string_literal: true

module Api
  module V1
    class OnboardingStepSubmissionsController < BaseController
      before_action :set_submission, only: %i[show update destroy]

      def index
        @submissions = OnboardingStepSubmission.includes(:company, :step).order(updated_at: :desc)
        @submissions = @submissions.where(company_id: params[:company_id]) if params[:company_id].present?
        @submissions = @submissions.where(step_id: params[:step_id]) if params[:step_id].present?
        render json: @submissions
      end

      def show
        render json: @submission
      end

      def create
        @submission = OnboardingStepSubmission.new(submission_params)
        if @submission.save
          render json: @submission, status: :created
        else
          render json: { errors: @submission.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @submission.update(submission_params)
          render json: @submission
        else
          render json: { errors: @submission.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @submission.destroy
        head :no_content
      end

      private

      def set_submission
        @submission = OnboardingStepSubmission.find(params[:id])
      end

      def submission_params
        params.require(:onboarding_step_submission).permit(
          :company_id, :step_id, :status, :completed_at, values: {}
        )
      end
    end
  end
end
