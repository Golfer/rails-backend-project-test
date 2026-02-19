# frozen_string_literal: true

# Shared examples for standard API resource behavior.
# Include in request specs that define `base_path` (and use UUID primary keys for 404 examples).

RSpec.shared_examples "returns 404 for unknown UUID on GET" do
  it "returns 404 for unknown id" do
    api_get("#{base_path}/#{SecureRandom.uuid}")
    expect(response).to have_http_status(:not_found)
  end
end

RSpec.shared_examples "returns 404 for unknown UUID on DELETE" do
  it "returns 404 for unknown id" do
    api_delete("#{base_path}/#{SecureRandom.uuid}")
    expect(response).to have_http_status(:not_found)
  end
end
