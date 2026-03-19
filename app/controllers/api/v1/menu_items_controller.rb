module Api
  module V1
    class MenuItemsController < ApplicationController
      include MenuItemsHelper, RestaurantHelper

      before_action :validation_find_menu_items, only: [:index]
      before_action :set_restaurant

      def index
        menu_items = MenuItem.limit(@per_page).offset((@page - 1) * @per_page)
        render_list(menu_items, page: @page, per_page: @per_page, total: menu_items.count)
      end

      def create
        item = @restaurant.menu_items.create!(menu_item_params)
        render_success item, status: :created
      end

      private

      def set_restaurant
        @restaurant = ValidatorRestaurant.new(params).find_one
      end

      def validation_find_menu_items
        @page, @per_page = ValidatorMenuItem.new(params).find_menu_items
      end

      def menu_item_params
        ValidatorMenuItem.new(params).create_update
      end
    end
  end
end
