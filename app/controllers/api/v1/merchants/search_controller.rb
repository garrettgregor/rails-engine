# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          render json: MerchantSerializer.new(Merchant.search_all(params[:name])), status: :ok
        end

        def show
          render json: MerchantSerializer.new(Merchant.search(params[:name])), status: :ok
        end
      end
    end
  end
end
