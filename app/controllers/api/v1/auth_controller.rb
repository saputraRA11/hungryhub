module Api
  module V1
    class AuthController < ApplicationController
      include AuthHelper

      attr_reader :validator_login, :validator_register

      before_action :validation_params
      skip_before_action :authenticate_user

      def register
        data = validator_register.register_params

        raise ConflictError, "Email has already been taken" if User.find_by(email: data[:email])

        user = User.create!(data)
        token = AuthenticationTokenService.call(user.id)
        render_success({ email: user.email, token: token }, status: :created)
      end

      def login
        data = validator_login.login_params
        user = User.find_by(email: data[:email])

        raise AuthenticationError, "Invalid email or password" unless user.authenticate(data[:password])

        token = AuthenticationTokenService.call(user.id)
        render_success({ email: user.email, token: token })
      end

      private

      def validation_params
        @validator_login = Validator.new(params)
        @validator_register = Validator.new(params)
      end
    end
  end
end
