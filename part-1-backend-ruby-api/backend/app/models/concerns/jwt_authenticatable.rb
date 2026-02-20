# frozen_string_literal: true

module JwtAuthenticatable
  ALGORITHM = "HS256"
  EXPIRY = 7.days

  class << self
    def encode(user)
      payload = {
        sub: user.id,
        company_id: user.company_id,
        exp: EXPIRY.from_now.to_i
      }
      JWT.encode(payload, secret, ALGORITHM)
    end

    def decode(token)
      payload, = JWT.decode(token, secret, true, { algorithm: ALGORITHM })
      payload
    rescue JWT::DecodeError
      nil
    end

    private

    def secret
      Rails.application.secret_key_base
    end
  end
end
