# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def current_user
    @current_user
  end

  def set_current_user
    payload = JwtAuthenticatable.decode(bearer_token)
    @current_user = payload && User.find_by(id: payload["sub"])
  end

  def require_authentication
    return if current_user

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  private

  def bearer_token
    request.authorization&.sub(/\ABearer\s+/i, "")
  end
end
