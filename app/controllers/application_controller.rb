class ApplicationController < ActionController::Base
  def handle_no_route
    render json: { error: t('no_route') }, status: :unprocessable_content
  end
end
