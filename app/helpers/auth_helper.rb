module AuthHelper
  class Validator
    def initialize(params)
      @params = params
    end

    def register_params
      @params.require([:email, :password])
      @params.permit(:email, :password)
    end

    def login_params
      @params.require([:email, :password])
      @params.permit(:email, :password)
    end
  end
end
