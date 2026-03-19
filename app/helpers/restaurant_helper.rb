module RestaurantHelper
  class Validator
    def initialize(params)
      @params = params
    end

    def create
      validate_permitted!(:name, :address, :opening_hours)
      validate_presence!(:name, :address, :opening_hours)
      @params.permit(:name, :address, :opening_hours)
    end

    def find_one
      restaurant = Restaurant.find_by(id: @params[:id])
      raise NotFoundError, "Restaurant not found" unless restaurant
      @restaurant = restaurant
    end

    def validate_presence!(*keys)
      missing = keys.select { |key| @params.fetch(key, "").to_s.strip.empty? }
      if missing.any?
        errors = missing.map { |k| "param is missing or the value is empty or invalid: #{k}" }
        raise ParameterMissingError.new(errors)
      end
    end

    def validate_permitted!(*keys)
      sent_keys = @params.except(:controller, :action, :id, :format, :restaurant).keys.map(&:to_sym)
      unpermitted = sent_keys - keys
      if unpermitted.any?
        errors = unpermitted.map { |k| "unpermitted parameter: #{k}" }
        raise UnpermittedParameterError.new(errors)
      end
    end
  end
end
