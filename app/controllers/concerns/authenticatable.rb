module Authenticatable extend ActiveSupport::Concern
  included do
    before_action :authenticate_user
  end

  private
  def authenticate_user
    token, _ = ActionController::HttpAuthentication::Token.token_and_options(request)

    raise UnauthorizedError, "Token not provided" if token.blank?

    user_id = AuthenticationTokenService.decode(token)

    raise UnauthorizedError, "Invalid token" if user_id.blank?

    @current_user = User.find(user_id)
  end
end
