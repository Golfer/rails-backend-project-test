# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Products", type: :request do
  def base_path
    "/api/v1/products"
  end

  describe "GET /api/v1/products" do
    it "returns a list of products" do
      create_list(:product, 2)
      api_get(base_path)
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to include("sku_id", "name", "company_id", "vendor_id")
    end

    it "filters by company_id when provided" do
      company = create(:company)
      create(:product, company: company)
      create(:product)
      api_get(base_path, company_id: company.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["company_id"]).to eq(company.id)
    end

    it "filters by vendor_id when provided" do
      vendor = create(:vendor)
      create(:product, vendor: vendor)
      create(:product)
      api_get(base_path, vendor_id: vendor.id)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["vendor_id"]).to eq(vendor.id)
    end
  end

  describe "GET /api/v1/products/:id" do
    it "returns the product by sku_id" do
      product = create(:product, sku_id: "SKU-UNIQUE-1", name: "Widget")
      api_get("#{base_path}/#{product.sku_id}")
      expect(response).to have_http_status(:ok)
      expect(json_response["sku_id"]).to eq("SKU-UNIQUE-1")
      expect(json_response["name"]).to eq("Widget")
    end

    it "returns 404 for unknown sku_id" do
      api_get("#{base_path}/UNKNOWN-SKU")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/products" do
    it "creates a product" do
      company = create(:company)
      vendor = create(:vendor, company: company)
      params = { product: { sku_id: "SKU-NEW-001", company_id: company.id, vendor_id: vendor.id, name: "New Product", lead_time_days: 14, forecasting_days: 60 } }
      expect { api_post(base_path, params) }.to change(Product, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response).to include("sku_id" => "SKU-NEW-001", "name" => "New Product")
    end

    it "returns 422 when required attributes are missing" do
      api_post(base_path, { product: { sku_id: "", name: "" } })
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/products/:id" do
    it "updates the product" do
      product = create(:product, forecasting_days: 30)
      api_put("#{base_path}/#{product.sku_id}", { product: { forecasting_days: 90 } })
      expect(response).to have_http_status(:ok)
      expect(json_response["forecasting_days"]).to eq(90)
      expect(product.reload.forecasting_days).to eq(90)
    end
  end

  describe "DELETE /api/v1/products/:id" do
    it "destroys the product" do
      product = create(:product)
      expect { api_delete("#{base_path}/#{product.sku_id}") }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
