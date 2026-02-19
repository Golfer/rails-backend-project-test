# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < BaseController
      before_action :set_company, only: %i[show update destroy]

      def index
        @companies = Company.order(created_at: :desc)
        render json: @companies
      end

      def show
        render json: @company
      end

      def create
        @company = Company.new(company_params)
        if @company.save
          render json: @company, status: :created
        else
          render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @company.update(company_params)
          render json: @company
        else
          render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @company.destroy
        head :no_content
      end

      private

      def set_company
        @company = Company.find(params[:id])
      end

      def company_params
        params.require(:company).permit(:name)
      end
    end
  end
end
