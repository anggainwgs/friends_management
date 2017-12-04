class Friend < ApplicationRecord
  belongs_to :account
  belongs_to :friend_account, class_name: "Account", foreign_key: :friend_account_id

  validates :account_id, :friend_account_id,  presence: true
  validates :account_id, uniqueness: { scope: :friend_account_id}
end
