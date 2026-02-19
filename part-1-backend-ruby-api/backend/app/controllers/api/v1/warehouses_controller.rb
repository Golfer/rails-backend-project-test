# frozen_string_literal: true

module Api
  module V1
    class WarehousesController < BaseController
      before_action :set_warehouse, only: %i[show update destroy]

      def index
        @warehouses = Warehouse.includes(:company).order(:name)
        @warehouses = @warehouses.where(company_id: params[:company_id]) if params[:company_id].present?
        render json: @warehouses
      end

      def show
        render json: @warehouse
      end

      def create
        @warehouse = Warehouse.new(warehouse_params)
        if @warehouse.save
          render json: @warehouse, status: :created
        else
          render json: { errors: @warehouse.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @warehouse.update(warehouse_params)
          render json: @warehouse
        else
          render json: { errors: @warehouse.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @warehouse.destroy
        head :no_content
      end

      private

      def set_warehouse
        @warehouse = Warehouse.find(params[:id])
      end

      def warehouse_params
        params.require(:warehouse).permit(:company_id, :name, :address)
      end
    end
  end
end
