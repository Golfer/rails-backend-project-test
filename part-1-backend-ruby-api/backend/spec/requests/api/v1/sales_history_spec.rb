# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::SalesHistory", type: :request do
  def base_path
    "/api/v1/sales_history"
  end

  describe "GET /api/v1/sales_history" do
    it "returns a list of sales history records" do
      create_list(:sales_history, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to include("id", "product_sku", "sale_date", "quantity")
    end

    it "filters by product_sku when provided" do
      product = create(:product)
      create(:sales_history, product_sku: product.sku_id)
      create(:sales_history)
      api_get(base_path, product_sku: product.sku_id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["product_sku"]).to eq(product.sku_id)
    end
  end

  describe "GET /api/v1/sales_history/:id" do
    it "returns the sales history record" do
      record = create(:sales_history, quantity: 42)
      api_get("#{base_path}/#{record.id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(record.id)
      expect(json_response["quantity"]).to eq(42)
    end

    it_behaves_like "returns 404 for unknown UUID on GET"
  end

  describe "POST /api/v1/sales_history" do
    it "creates a sales history record" do
      product = create(:product)
      params = {
        sales_history: {
          product_sku: product.sku_id,
          sale_date: "2024-01-15",
          quantity: 100
        }
      }
      expect { api_post(base_path, params) }.to change(SalesHistory, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["product_sku"]).to eq(product.sku_id)
      expect(json_response["sale_date"]).to eq("2024-01-15")
      expect(json_response["quantity"]).to eq(100)
    end

    it "returns 422 when required attributes are missing" do
      api_post(base_path, { sales_history: { product_sku: nil, quantity: nil } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/sales_history/:id" do
    it "updates the record" do
      record = create(:sales_history, quantity: 10)
      api_put("#{base_path}/#{record.id}", { sales_history: { quantity: 20 } })
      expect(response).to have_http_status(:ok)
      expect(json_response["quantity"]).to eq(20)
      expect(record.reload.quantity).to eq(20)
    end
  end

  describe "DELETE /api/v1/sales_history/:id" do
    it "destroys the record" do
      record = create(:sales_history)
      expect { api_delete("#{base_path}/#{record.id}") }.to change(SalesHistory, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
