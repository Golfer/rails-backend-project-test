# frozen_string_literal: true

module Api
  module V1
    module Auth
      class RegistrationsController < BaseController
        skip_before_action :set_current_user

        def create
          user = User.new(registration_params)
          if user.save
            render json: auth_response(user), status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def registration_params
          params.require(:user).permit(:company_id, :email, :password, :password_confirmation, :role)
        end

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
