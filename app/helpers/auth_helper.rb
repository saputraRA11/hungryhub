module AuthHelper
  class Validator
    def initialize(params)
      @params = params
    end

    def register_params
      validate_presence!(:email, :password)
      @params.permit(:email, :password)
    end

    def login_params
      validate_presence!(:email, :password)
      @params.permit(:email, :password)
    end

    private

    def validate_presence!(*keys)
      missing = keys.select { |key| @params.fetch(key, "").to_s.strip.empty? }
      if missing.any?
        errors = missing.map { |k| "param is missing or the value is empty or invalid: #{k}" }
        raise HandlingError::ParameterMissingError.new(errors)
      end
    end
  end
end
