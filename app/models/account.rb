class Account < ApplicationRecord
  has_many :friends
  before_save :email_checker

  def self.connect_email(emails)
    account_email = emails.first
    friend_email = emails.last

    if emails.count.eql?(2) and !account_email.eql?(friend_email)
      account = self.where(email: account_email).first_or_create
      friends = self.where(email: friend_email).first_or_create
      acc = account.friends.new(friend_account_id: friends.id)
      acc.save
    end
  end

  def friends_list
    self.friends.map{ |x| x.friend_account.email }
  end

  def email_checker
    self.email.match(/^.+@.+$/).present?
  end

end
