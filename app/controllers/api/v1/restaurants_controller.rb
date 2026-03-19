module Api
  module V1
    class RestaurantsController < ApplicationController
      include RestaurantHelper

      before_action :set_restaurant, only: [ :show, :update, :destroy ]
      before_action :validation_create, only: [ :create, :update ]
      before_action :validation_find_restaurants, only: [ :index ]


      def index
        restaurants = Restaurant.all.limit(@per_page).offset((@page - 1) * @per_page)
        render_list(restaurants, page: @page, per_page: @per_page, total: restaurants.count)
      end

      def show
        render_success(@restaurant, status: :ok)
      end

      def create
        restaurant = Restaurant.create!(@payload_data)
        render_success(restaurant, status: :created)
      end

      def update
        @restaurant.update!(@payload_data)
        render_success(@restaurant, status: :ok)
      end

      def destroy
        @restaurant.destroy!
        render_success(@restaurant, status: :ok)
      end

      private
        def set_restaurant
          @restaurant = Validator.new(params).find_one
        end

        def validation_create
          @payload_data = Validator.new(params).create_update
        end

        def validation_find_restaurants
          @page, @per_page = Validator.new(params).find_restaurants
        end
    end
  end
end
