class Status < ApplicationRecord
  belongs_to :account
  validates :account_id,  presence: true

  def self.add(sender_email, text)
    sender = Account.find_by_email(sender_email)

    if sender.present?
      friend_emails_ids   = sender.friends.map{|x| x.friend_account_id}
      subscribe_email_ids = sender.subscribes.follow.map{|x| x.request_account_id}
      mention_emails_ids  = Status.scan_emails(text)

      recipient_ids = friend_emails_ids + subscribe_email_ids + mention_emails_ids

      status = self.new(account_id: sender.id, text: text, recipient_ids: recipient_ids)

      [status.save, status.recipient_list]
    else
      [false, "sender not found"]
    end
  end

  # mention email will create account
  def self.scan_emails(text)
    emails = text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
    email_ids = []
    emails.each do |email|
      account = Account.where(email: email).first_or_create

      email_ids << account.id rescue nil 
    end

    return email_ids.compact
  end

  def recipient_list
    recipient_ids = eval(self.recipient_ids)

    Account.where(id: recipient_ids).pluck(:email)
  end

end
