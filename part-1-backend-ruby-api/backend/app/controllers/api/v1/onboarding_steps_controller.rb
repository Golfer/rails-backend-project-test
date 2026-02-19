# frozen_string_literal: true

module Api
  module V1
    class OnboardingStepsController < BaseController
      before_action :set_step, only: %i[show update destroy]

      def index
        @steps = OnboardingStep.order(:sort_order)
        render json: @steps
      end

      def show
        render json: @step
      end

      def create
        @step = OnboardingStep.new(step_params)
        if @step.save
          render json: @step, status: :created
        else
          render json: { errors: @step.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @step.update(step_params)
          render json: @step
        else
          render json: { errors: @step.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @step.destroy
        head :no_content
      end

      private

      def set_step
        @step = OnboardingStep.find(params[:id])
      end

      def step_params
        params.require(:onboarding_step).permit(
          :title, :slug, :sort_order, :category,
          :is_active, :is_mandatory, :dependency_step_id
        )
      end
    end
  end
end
