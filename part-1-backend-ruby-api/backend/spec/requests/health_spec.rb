# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Health", type: :request do
  describe "GET /up" do
    it "returns 200 when app is healthy" do
      api_get("/up")
      expect(response).to have_http_status(:ok)
    end
  end
end
