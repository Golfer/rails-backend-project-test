# frozen_string_literal: true

module RequestHelpers
  REQUEST_SPEC_HOST = "localhost"

  def json_response
    JSON.parse(response.body)
  end

  def api_headers
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json",
      "HTTP_HOST" => REQUEST_SPEC_HOST
    }
  end

  def request_url(path)
    path.start_with?("http") ? path : "http://#{REQUEST_SPEC_HOST}#{path}"
  end

  def api_get(path, query_params = {})
    get request_url(path), params: query_params, headers: api_headers
  end

  def api_post(path, body = {})
    post request_url(path), params: body.to_json, headers: api_headers
  end

  def api_put(path, body = {})
    put request_url(path), params: body.to_json, headers: api_headers
  end

  def api_delete(path)
    delete request_url(path), headers: api_headers
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request

  config.before(:each, type: :request) do
    host! RequestHelpers::REQUEST_SPEC_HOST
  end
end
