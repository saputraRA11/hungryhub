module Respondable
  extend ActiveSupport::Concern

  def render_success(data, status: :ok)
    render json: {
      status_code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
      messages: [],
      data: data
    }, status: status
  end

  def render_list(collection, page:, per_page:, total:)
    render json: {
      status_code: 200,
      messages: [],
      data: {
        items: collection,
        page: page.to_i,
        per_page: per_page.to_i,
        total: total.to_i
      }
    }, status: :ok
  end

  def render_error(messages, status:)
    messages = Array(messages)
    render json: {
      status_code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
      messages: messages,
      data: nil
    }, status: status
  end
end
