# frozen_string_literal: true

module Api
  module V1
    class SyncStatusesController < BaseController
      before_action :set_sync_status, only: %i[show update destroy]

      def index
        @sync_statuses = SyncStatus.includes(:company).order(id: :desc)
        @sync_statuses = @sync_statuses.where(company_id: params[:company_id]) if params[:company_id].present?
        render json: @sync_statuses
      end

      def show
        render json: @sync_status
      end

      def create
        @sync_status = SyncStatus.new(sync_status_params)
        if @sync_status.save
          render json: @sync_status, status: :created
        else
          render json: { errors: @sync_status.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @sync_status.update(sync_status_params)
          render json: @sync_status
        else
          render json: { errors: @sync_status.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @sync_status.destroy
        head :no_content
      end

      private

      def set_sync_status
        @sync_status = SyncStatus.find(params[:id])
      end

      def sync_status_params
        params.require(:sync_status).permit(
          :company_id, :entity_type, :total_count, :synced_count, :is_finished
        )
      end
    end
  end
end
