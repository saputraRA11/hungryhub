module HandlingError
  extend ActiveSupport::Concern

  class ApiError < StandardError; end
  class AuthenticationError < ApiError; end
  class AuthorizationError < ApiError; end
  class NotFoundError < ApiError; end
  class ValidationError < ApiError; end
  class InternalServerError < ApiError; end

  included do
    rescue_from HandlingError::ApiError, with: :handle_error
  end

  private

  def handle_error(e)
    case e
    when AuthenticationError
      render_error([ "System Got Error: " + e.message ], status: :unauthorized)
    when AuthorizationError
      render_error([ "System Got Error: " + e.message ], status: :forbidden)
    when NotFoundError
      render_error([ "System Got Error: " + e.message ], status: :not_found)
    when ValidationError
      render_error([ "System Got Error: " + e.message ], status: :unprocessable_entity)
    when InternalServerError
      render_error([ "System Got Error: " + e.message ], status: :internal_server_error)
    else
      render_error([ "System Got Error: " + e.message ], status: :internal_server_error)
    end
  end
end
