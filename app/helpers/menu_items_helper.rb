module MenuItemsHelper
  class ValidatorMenuItem
    MAX_PAGINATION_PER_PAGE = 100

    def initialize(params)
      @params = params
    end

    def find_menu_items
      validate_permitted!(:page, :per_page, :category, :search)
      per_page = [
        @params.fetch(:per_page, 10).to_i,
        MAX_PAGINATION_PER_PAGE
      ].min

      page = @params.fetch(:page, 1).to_i

      [ page, per_page ]
    end

    def create_update
      validate_permitted!(:name, :description, :price, :category, :is_available)
      validate_presence!(:name, :description, :price, :category, :is_available) if @params[:action] == :create
      raise NotFoundError, "Category not found in #{MenuItem::CATEGORIES.join(", ")}" if !MenuItem::CATEGORIES.include?(@params[:category])
      @params.permit(:name, :description, :price, :category, :is_available)
    end

    def find_one(id_key = :id)
      menu_item = MenuItem.find_by(id: @params[id_key])
      raise NotFoundError, "Menu item not found" unless menu_item
      @menu_item = menu_item
    end

    def validate_presence!(*keys)
      missing = keys.select { |key| @params.fetch(key, "").to_s.strip.empty? }
      if missing.any?
        errors = missing.map { |k| "param is missing or the value is empty or invalid: #{k}" }
        raise ParameterMissingError.new(errors)
      end
    end

    def validate_permitted!(*keys)
      sent_keys = @params.except(:controller, :action, :id, :format, :menu_item).keys.map(&:to_sym)
      unpermitted = sent_keys - keys
      if unpermitted.any?
        errors = unpermitted.map { |k| "unpermitted parameter: #{k}" }
        raise UnpermittedParameterError.new(errors)
      end
    end
  end
end
