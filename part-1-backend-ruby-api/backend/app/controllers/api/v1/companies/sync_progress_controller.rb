# frozen_string_literal: true

module Api
  module V1
    module Companies
      class SyncProgressController < Api::V1::BaseController
        before_action :set_company

        # GET /api/v1/companies/:company_id/sync_progress
        def show
          list = SyncProgressAggregator.new(@company).progress_list
          render json: { syncs: list }
        end

        private

        def set_company
          @company = Company.find(params[:company_id])
        end
      end
    end
  end
end
