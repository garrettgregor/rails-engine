# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        new_item = Item.create!(item_params)
        render json: ItemSerializer.new(new_item), status: :created
      end

      def destroy
        item = Item.find(params[:id])
        item.destroy
      end

      def update
        item_to_update = Item.find(params[:id])
        if item_to_update.update(item_params)
          render json: ItemSerializer.new(item_to_update), status: :accepted
        else
          render status: :not_found
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
