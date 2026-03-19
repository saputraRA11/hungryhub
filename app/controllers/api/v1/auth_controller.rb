module Api
  module V1
    class AuthController < ApplicationController
      include AuthHelper

      attr_reader :validator_login, :validator_register

      before_action :validate_register_params, only: [ :register ]
      before_action :validate_login_params, only: [ :login ]
      skip_before_action :authenticate_user

      def register
        data = @register_data

        raise ConflictError, "Email has already been taken" if User.find_by(email: data[:email])

        user = User.create!(data)
        token = AuthenticationTokenService.call(user.id)
        render_success({ email: user.email, token: token }, status: :created)
      end

      def login
        data = @login_data
        user = User.find_by(email: data[:email])

        raise AuthenticationError, "Invalid email or password" unless user.authenticate(data[:password])

        token = AuthenticationTokenService.call(user.id)
        render_success({ email: user.email, token: token })
      end

      private

      def validate_register_params
        @validator_register = Validator.new(params)
        @register_data = @validator_register.register_params
      end

      def validate_login_params
        @validator_login = Validator.new(params)
        @login_data = @validator_login.login_params
      end
    end
  end
end
