# frozen_string_literal: true

module Api
  module V1
    module Auth
      class RegistrationsController < BaseController
        skip_before_action :set_current_user

        def create
          company = find_or_create_company
          return render json: { errors: ["Company is required: provide company_id or company_name"] }, status: :unprocessable_entity if company.nil?
          return render json: { errors: company.errors.full_messages }, status: :unprocessable_entity if company.is_a?(Company) && !company.persisted?

          user = User.new(registration_params.merge(company_id: company.id))
          if user.save
            render json: auth_response(user), status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        # Returns a Company (existing or newly created), nil if company_id/company_name missing, or an invalid Company
        def find_or_create_company
          if params.dig(:user, :company_id).present?
            return Company.find_by(id: params.dig(:user, :company_id))
          end

          name = params.dig(:user, :company_name).presence
          return nil unless name

          company = Company.new(name: name)
          company.save ? company : company
        end

        def registration_params
          params.require(:user).permit(:email, :password, :password_confirmation, :role)
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
