module Exceptionable
  extend ActiveSupport::Concern

  included do
    rescue_from ArgumentError, with: :handle_argument_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_incorrect_request
    rescue_from ActiveRecord::RecordInvalid, with: :handle_incorrect_request
    rescue_from ActiveRecord::RecordNotSaved, with: :handle_incorrect_request
    rescue_from ActionController::UnknownFormat, with: :handle_incorrect_request
  end

  def handle_no_route
    render json: { error: t('no_route') }, status: :unprocessable_content
  end

  private

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: :internal_server_error
  end

  def handle_argument_error
    render json: { error: error.message }, status: :unprocessable_content
  end

  def handle_incorrect_request(error)
    render json: { error: error.message }, status: :unprocessable_content
  end
end
