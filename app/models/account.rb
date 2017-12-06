class Account < ApplicationRecord
  has_many :friends
  has_many :subscribes
  has_many :statuses

  validates :email,  presence: true

  before_create :email_checker

  def self.connect_email(emails)
    account_email = emails.first
    friend_email = emails.last

    if emails.count.eql?(2) and !account_email.eql?(friend_email)
      account = self.where(email: account_email).first_or_create
      friend = self.where(email: friend_email).first_or_create
      acc = account.friends.new(friend_account_id: friend.id)
      followback_acc = friend.friends.new(friend_account_id: account.id)
      acc.save and followback_acc.save
    end
  end

  def self.find_common_friend(params_emails)
    emails = eval(params_emails) 
    common_friend_ids = Friend.joins(:account).where("accounts.email IN (?)",emails).group_by(&:friend_account_id).map{|x| x.first if x.last.count.eql?(2) }

    self.where(id: common_friend_ids)
  end

  def friends_list
    self.friends.map{ |x| x.friend_account.email }
  end

  def email_checker
    self.email.match(/^.+@.+$/).present? ? true : throw(:abort)
  end

end
