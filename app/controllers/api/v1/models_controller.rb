module Api
  module V1
    class ModelsController < ApplicationController
      before_action :set_model, only: %i[ show update destroy]
      before_action :is_admin?, only: %i[ create update destroy]
      def index
        @models = Model.all

        render json: @models
      end

      def show
        render json: @model
      end

      def create
        @model = Model.create(model_params)

        if @model.save
          render json: @model, status: :created
        else
          render json: @model.errors, status: :unprocessable_entity
        end
      end

      def update
        if @model.update(model_params)
          render json: @model
        else
          render json: @model.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @model.destroy
      end

      private

      def set_model
        @model = Model.find(params[:id])
      end

      def model_params
        params.require(:model).permit(:name, :brand_id)
      end

    end
  end
end

