class ApplicationController < ActionController::API
  include Authenticatable
  include Respondable
  include HandlingError

  around_action :log_request

  def log_request
    request_uuid = SecureRandom.uuid
    response.set_header("uuid", request_uuid)

    req_data = {
      uuid: request_uuid,
      method: request.method,
      body: request.body.read,
      params: params.to_unsafe_h,
      ip: request.remote_ip,
      user_agent: request.user_agent,
      timestamp: Time.current
    }
    Rails.logger.info "[REQUEST] #{request.method} #{request.fullpath} - #{req_data.to_json}"

    yield
  ensure
    res_data = {
      uuid: request_uuid,
      status_code: response.status,
      body: response.body,
      timestamp: Time.current
    }
    Rails.logger.info "[RESPONSE] #{request.method} #{request.fullpath} - #{res_data.to_json}"
  end
end
