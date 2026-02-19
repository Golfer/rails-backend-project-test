# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.includes(:company).order(:email)
        @users = @users.where(company_id: params[:company_id]) if params[:company_id].present?
        render json: @users
      end

      def show
        render json: @user
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:company_id, :email, :role)
      end
    end
  end
end
