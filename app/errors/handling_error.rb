module HandlingError
  extend ActiveSupport::Concern

  class ApiError < StandardError; end
  class AuthenticationError < ApiError; end
  class AuthorizationError < ApiError; end
  class NotFoundError < ApiError; end
  class ValidationError < ApiError; end
  class ConflictError < ApiError; end
  class UnauthorizedError < ApiError; end
  class BadRequestError < ApiError; end
  class InternalServerError < ApiError; end
  class ParameterMissingError < ApiError
    attr_reader :messages_list
    def initialize(messages_list)
      @messages_list = Array(messages_list)
      super(@messages_list.join(", "))
    end
  end

  included do
    rescue_from HandlingError::ApiError, with: :handle_error
    rescue_from ActionController::ParameterMissing, with: :handle_error
  end

  private

  def handle_error(e)
    messages =
      if e.respond_to?(:messages_list) && e.messages_list.is_a?(Array)
        e.messages_list.map { |msg| "#{msg}" }
      else
        [ "#{e.message}" ]
      end

    status =
      case e
      when AuthenticationError, UnauthorizedError
        :unauthorized
      when AuthorizationError
        :forbidden
      when NotFoundError
        :not_found
      when ValidationError
        :unprocessable_entity
      when ConflictError
        :conflict
      when BadRequestError, ParameterMissingError
        :bad_request
      else
        :internal_server_error
      end

    render_error(messages, status: status)
  end
end
