# frozen_string_literal: true

module Api
  module V1
    module Auth
      class MeController < BaseController
        before_action :require_authentication

        def show
          render json: current_user.as_json(only: %i[id email role company_id])
        end
      end
    end
  end
end
