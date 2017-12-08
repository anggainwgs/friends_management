require 'rails_helper'

RSpec.describe Status, type: :model do
  before do
    @emails = 5.times.map{|x| Faker::Internet.email}
    @pair_emails = @emails.combination(2).to_a

    @pair_emails.each do |pair_email|
      Account.connect_email(pair_email)
    end
  end

  context 'when scan text emails #scan_emails' do
    it 'should find recipient_ids from text' do
      content_text = @emails.join(" and ")
      email_ids = Account.where(email: @emails).pluck(:id)
      expect(Status.scan_emails(content_text)).to eq(email_ids)
    end
  end

  context 'when add status/update #add' do
    it 'should not create when sender account not registered' do
      email = Faker::Internet.email

      expect(Status.add(email, "Hello").first).to eq(false)
    end

    it 'should find sender account and return #recipient_list' do
      email = @emails.first
      status = Status.add(email, "Hello")

      expect(status.first).to eq(true)
      expect(status.last).to eq(Status.last.recipient_list)
    end
  end

end
