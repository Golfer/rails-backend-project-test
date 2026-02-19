# frozen_string_literal: true

module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[show update destroy]

      def index
        @products = Product.includes(:company, :vendor).order(:name)
        @products = @products.where(company_id: params[:company_id]) if params[:company_id].present?
        @products = @products.where(vendor_id: params[:vendor_id]) if params[:vendor_id].present?
        render json: @products
      end

      def show
        render json: @product
      end

      def create
        @product = Product.new(product_params)
        if @product.save
          render json: @product, status: :created
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          :sku_id, :company_id, :vendor_id, :name,
          :lead_time_days, :days_of_stock, :forecasting_days
        )
      end
    end
  end
end
