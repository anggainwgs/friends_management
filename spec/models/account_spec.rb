require 'rails_helper'

RSpec.describe Account, type: :model do

  it { have_many :friends}
  it { have_many :subscribes}
  it { have_many :statuses}

  context 'when create account' do
    subject { Account.new(email: nil) }

    it 'should not valid without email' do
      expect(subject).to_not be_valid
    end

    it 'should valid with email string format' do
      subject.email = Faker::Internet.email
      expect(subject).to be_valid
    end
  end

  context '#connect_email' do
    it 'should not connect for single email' do
      emails = []
      expect(Account.connect_email(emails)).to eq nil
    end

    it 'should input email format' do
      emails = ["string", Faker::Internet.email]
      expect(Account.connect_email(emails)).to eq false
    end

    it 'should valid with array emails' do
      emails = 2.times.map{|x| Faker::Internet.email}
      expect(Account.connect_email(emails)).to eq true
    end
  end

  context '#find_common and #friend_list' do
    it 'find same friend' do
      emails = 3.times.map{|x| Faker::Internet.email}
      pair_emails = emails.combination(2).to_a

      pair_emails.each do |pair_email|
        Account.connect_email(pair_email)
      end

      expect(Account.find_common_friend(pair_emails.first.to_s).pluck(:email)) == (emails - pair_emails.first)

      account = Account.first
      expect(account.friends_list) == (emails - [account.email])
    end
  end

end