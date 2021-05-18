class ApplicationController < ActionController::Base

  def not_found
    render json: { error: 'not_found' }
  end

  # Authorize request
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      is_active_token = UserToken.where(token: header, active: 1).present?
      raise ActiveRecord::RecordNotFound unless is_active_token

      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
