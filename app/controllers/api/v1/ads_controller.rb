module Api
  module V1
    class AdsController < ApplicationController
      before_action :set_ad, only: %i[ show update destroy]
      #before_action :is_admin?, only: %i[ create update destroy]

      def index
        @ads = Ad.all.with_attached_photos
        render json: @ads.map { |ad| ad.as_json.merge({ photos: ad.photos.map{|photo| ({ photo: url_for(photo) })} })     }
      end

      def show
        render json: @ad
      end

      def create
        @car = Car.create(car_params)
        if !@car.save
          render json: @car.errors, status: :unprocessable_entity
        end

        @ad = Ad.create(ad_params)
        if @ad.save
          render json: @ad.as_json.merge({ photos: @ad.photos.map{|photo| ({ photo: url_for(photo) })} }) , status: :created
        else
          render json: @ad.errors, status: :unprocessable_entity
        end
      end

      def update
        @car = @ad.car
        if !@car.update(car_params)
          render json: @car.errors, status: :unprocessable_entity
        end

        if @ad.update(ad_params)
          render json: @ad.as_json.merge({ photos: @ad.photos.map{|photo| ({ photo: url_for(photo) })} }) , status: :created
        else
          render json: @ad.errors, status: :unprocessable_entity
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
