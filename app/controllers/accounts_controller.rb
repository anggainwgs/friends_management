class AccountsController < ApplicationController
  before_action :subscribe_params, only: [:add_subscribe, :block_subscribe]
  before_action :set_format_response

  def landing;end

  def index
    account = Account.where(email: params[:email]).first
    if account.present?
      content = { success: true, friends: account.friends_list, count: account.friends_list.count }
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

  def common_friends
    common_friends = Account.find_common_friend(params[:emails])
    content = { success: true, friends: common_friends.pluck(:email), count: common_friends.count }

    render json: content.to_json
  end

  def add_subscribe
    if Subscribe.add(@requestor, @target)
      render json: { success: true }
    else
      render_errors("add subscribe failed", 401)
    end
  end

  def block_subscribe
    if Subscribe.add(@requestor, @target, false)
      render json: { success: true }
    else
      render_errors("block subscribe failed", 401)
    end
  end

  def add_update
    status = Status.add(params[:sender], params[:text])
    if status.first
      render json: { success: status.first, recipients: status.last}
    else
      render_errors(status.last, 401)
    end
  end

  def create
     account = Account.new(email: params[:email])
    if account.save
      render json: { success: true, message: "add account success" }
    else
      render_errors(account.errors.messages, 401)
    end
  end

  def subscribe_params
    @requestor = params[:requestor]
    @target    = params[:target]
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
