
module Api
  module V1
    class BrandsController < ApplicationController
      before_action :set_brand, only: %i[ show update destroy]
      before_action :moderator?, only: %i[ create update destroy]
      def index
        @brands = Brand.all

        render json: @brands
      end

      def show
        render json: @brand
      end

      def create
        @brand = Brand.create(brand_params)

        if @brand.save
          render json: @brand, status: :created
        else
          render json: @brand.errors, status: :unprocessable_entity
        end
      end

      def update
        if @brand.update(brand_params)
          render json: @brand
        else
          render json: @brand.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @brand.destroy
      end

      private
      def set_brand
        @brand = Brand.find(params[:id])
      end
      def brand_params
        params.require(:brand).permit(:name)
      end
    end
  end
end

