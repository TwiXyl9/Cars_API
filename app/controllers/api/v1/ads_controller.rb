module Api
  module V1
    class AdsController < ApplicationController
      before_action :set_ad, only: %i[ show update destroy]
      before_action :authenticate_user!, only: %i[ create update destroy]

      def index
        @ads = Ad.all.with_attached_photos
        render json: AdsRepresenter.new(@ads).to_json
      end

      def show
        render json: AdRepresenter.new(@ad).to_json
      end

      def create
        @car = Car.find_or_create_by(creation_year: car_params[:creation_year], engine_capacity: car_params[:engine_capacity], model_id: car_params[:model_id])
        if !@car.id
          render json: @car.errors, status: :unprocessable_entity if !@car.save
        end
        @ad = Ad.create(ad_params)
        if @ad.save
          render json: AdRepresenter.new(@ad).to_json , status: :created
        else
          render json: @ad.errors, status: :unprocessable_entity
        end
      end

      def update
        @car = @ad.car
        if !@car.update(car_params)
          render json: @car.errors, status: :unprocessable_entity
        else
          if @ad.update(ad_params)
            render json: AdRepresenter.new(@ad).to_json , status: :created
          else
            render json: @ad.errors, status: :unprocessable_entity
          end
        end

      end

      def destroy
        @ad.destroy
      end

      private
      def set_ad
        @ad = Ad.find(params[:id])
      end

      def ad_params
        params[:ad].merge!(:car_id => @car.id)
        params.require(:ad).permit(:description, :price, :stage, :reason_for_rejection, :user_id, :car_id, {photos: []})
      end

      def car_params
        params.require(:car).permit(:creation_year, :engine_capacity, :model_id)
      end
    end
  end
end
