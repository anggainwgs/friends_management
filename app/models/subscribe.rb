class Subscribe < ApplicationRecord
  # account as target
  # request_account as subscriber 

  belongs_to :account
  belongs_to :request_account, class_name: "Account", foreign_key: :request_account_id

  validates :account_id, :request_account_id,  presence: true

  scope :follow, -> {where(block: false)}

  def self.add(request_email, target_email, status = nil)
    target  = Account.find_by_email(target_email)
    requestor = Account.find_by_email(request_email)

    subscribe = self.where(account_id: target,request_account_id: requestor).first_or_create
    if subscribe.id.present?
      current_status = status.present? ? status : false
      subscribe.update(block: current_status)
    else
      return false  
    end
  end

end
