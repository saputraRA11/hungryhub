module Authenticatable extend ActiveSupport::Concern
  included do
    before_action :authenticate_user
  end

  private
  def authenticate_user
    token, _ = ActionController::HttpAuthentication::Token.token_and_options(request)

    return render_error("Token not provided", status: :unauthorized) if token.blank?

    user_id = AuthenticationTokenService.decode(token)

    return render_error("Invalid token", status: :unauthorized) if user_id.blank?

    @current_user = User.find(user_id)
  end
end
