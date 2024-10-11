module Exceptionable
  extend ActiveSupport::Concern

  def handle_no_route
    render json: { error: t('no_route') }, status: :unprocessable_content
  end

  private

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: :internal_server_error
  end
end
