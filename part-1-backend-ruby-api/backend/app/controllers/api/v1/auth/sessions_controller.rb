# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < BaseController
        skip_before_action :set_current_user

        def create
          user = User.find_by(email: params[:email]&.downcase)
          if user&.authenticate(params[:password])
            render json: auth_response(user)
          else
            render json: { error: "Invalid email or password" }, status: :unauthorized
          end
        end

        private

        def auth_response(user)
          {
            user: user.as_json(only: %i[id email role company_id]),
            token: JwtAuthenticatable.encode(user)
          }
        end
      end
    end
  end
end
