# frozen_string_literal: true

module Api
  module V1
    class SalesHistoryController < BaseController
      before_action :set_record, only: %i[show update destroy]

      def index
        @records = SalesHistory.includes(:product).order(sale_date: :desc)
        @records = @records.where(product_sku: params[:product_sku]) if params[:product_sku].present?
        render json: @records
      end

      def show
        render json: @record
      end

      def create
        @record = SalesHistory.new(record_params)
        if @record.save
          render json: @record, status: :created
        else
          render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @record.update(record_params)
          render json: @record
        else
          render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @record.destroy
        head :no_content
      end

      private

      def set_record
        @record = SalesHistory.find(params[:id])
      end

      def record_params
        params.require(:sales_history).permit(:product_sku, :sale_date, :quantity)
      end
    end
  end
end
