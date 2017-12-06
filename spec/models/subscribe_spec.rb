require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  context '#add Subscribe' do
    it 'should not valid without exist email Account' do
      expect(Subscribe.add(Faker::Internet.email, Faker::Internet.email)).to eq false
    end

    it 'should valid with exist email Account' do
      3.times.map{ |x| Account.create(email: Faker::Internet.email) }
      expect(Subscribe.add(Account.first.email, Account.last.email)).to eq true
    end
  end

end
