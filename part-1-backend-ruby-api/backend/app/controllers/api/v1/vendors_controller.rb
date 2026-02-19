# frozen_string_literal: true

module Api
  module V1
    class VendorsController < BaseController
      before_action :set_vendor, only: %i[show update destroy]

      def index
        @vendors = Vendor.includes(:company).order(:name)
        @vendors = @vendors.where(company_id: params[:company_id]) if params[:company_id].present?
        render json: @vendors
      end

      def show
        render json: @vendor
      end

      def create
        @vendor = Vendor.new(vendor_params)
        if @vendor.save
          render json: @vendor, status: :created
        else
          render json: { errors: @vendor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @vendor.update(vendor_params)
          render json: @vendor
        else
          render json: { errors: @vendor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @vendor.destroy
        head :no_content
      end

      private

      def set_vendor
        @vendor = Vendor.find(params[:id])
      end

      def vendor_params
        params.require(:vendor).permit(:company_id, :name, contact_info: {})
      end
    end
  end
end
