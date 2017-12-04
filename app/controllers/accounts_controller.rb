class AccountsController < ApplicationController
  def index
    account = Account.where(email: params[:email]).first
    if account.present?
      content = { success: "success", friends: account.friends_list }
      render json: content.to_json
    else
      render_errors("email not found", 401)      
    end
  end

  def connect
    if Account.connect_email(params[:friends])
      render json: { success: true }
    else
      render_errors("email failed to connect", 401)
    end
  end

  def render_errors(message, code)
    render json: {
      error: message,
      status: code
    }, status: code
  end

  protected

  def set_format_response
    request.format = :json
  end
end
