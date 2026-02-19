# frozen_string_literal: true

module Api
  module V1
    class OnboardingProcessesController < BaseController
      before_action :set_process, only: %i[show update destroy]

      def index
        @processes = OnboardingProcess.includes(:company, :current_step).order(id: :desc)
        @processes = @processes.where(company_id: params[:company_id]) if params[:company_id].present?
        render json: @processes
      end

      def show
        render json: @process
      end

      def create
        @process = OnboardingProcess.new(process_params)
        if @process.save
          render json: @process, status: :created
        else
          render json: { errors: @process.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @process.update(process_params)
          render json: @process
        else
          render json: { errors: @process.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @process.destroy
        head :no_content
      end

      private

      def set_process
        @process = OnboardingProcess.find(params[:id])
      end

      def process_params
        params.require(:onboarding_process).permit(:company_id, :current_step_id)
      end
    end
  end
end
