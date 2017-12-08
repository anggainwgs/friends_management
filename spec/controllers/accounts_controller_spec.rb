require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  before do
    @emails = 5.times.map{|x| Faker::Internet.email}
    @pair_emails = @emails.combination(2).to_a

    @pair_emails.each do |pair_email|
      Account.connect_email(pair_email)
    end
  end

  context '#1 post /connect' do
    it "post connect_email failed if params not an email format" do
      post :connect, params: { friends: ["test", Faker::Internet.email] }, format: :json

      expect(eval(response.body)).to eq({error: "email failed to connect", status: 401})
    end

    it "post connect_email params must email format" do
      emails = 2.times.map{|x| Faker::Internet.email}
      post :connect, params: { friends: emails }, format: :json

      expect(eval(response.body)).to eq({success: true})
    end
  end

  context '#2 get /account' do
  	it 'returns errors email account must exist' do 
  		get :index, params: {email: Faker::Internet.email}, format: :json
  		errors_respond = { error: "email not found", status: 401 }

  		expect(eval(response.body)).to eq errors_respond
  	end

    it 'returns friends from email params' do
      get :index, params: {email: @emails.first}, format: :json
      friend_emails = @emails - [@emails.first]
      expect(eval(response.body)[:friends]).to eq friend_emails
    end
  end

  context '#3 get /common_friends' do
    it "get common_friends won't find unregister friend emails" do
      get :common_friends, params: { emails: ["test", Faker::Internet.email] }, format: :json

      expect(eval(response.body)[:count]).to eq(0)
    end

    it "get common_friends find registered friend emails" do
      get :common_friends, params: { emails: @pair_emails.first }, format: :json
      expect(eval(response.body)[:friends]).to eq(@emails - @pair_emails.first)
    end
  end


  context '#4 post /add_subscribe' do
    it "add_subscribe won't find unregister friend emails" do
      post :add_subscribe, params: { requestor: @emails.last, target: Faker::Internet.email }, format: :json

      expect(eval(response.body)[:status]).to eq(401)
    end

    it "add_subscribe valid for registered account email" do
      post :add_subscribe, params: { requestor: @emails.last, target: @emails.first }, format: :json

      expect(eval(response.body)[:success]).to eq(true)
    end
  end

  context '#5 post /block_subscribe' do
    it "block_subscribe won't block unregister friend emails" do
      post :block_subscribe, params: { requestor: @emails.last, target: Faker::Internet.email }, format: :json

      expect(eval(response.body)[:status]).to eq(401)
    end

    it "block_subscribe valid for registered account email" do
      post :block_subscribe, params: { requestor: @emails.last, target: @emails.first }, format: :json

      expect(eval(response.body)[:success]).to eq(true)
    end
  end

  context '#6 post /add_update' do
    it "add_update won't create with unregister email account" do
      post :add_update, params: { sender: Faker::Internet.email, text: "won't create" }

      expect(eval(response.body)[:status]).to eq(401)
    end

    it "add_update valid for registered account email" do
      post :add_update, params: { sender: @emails.first, text: "hello world" }

      expect(eval(response.body)[:success]).to eq(true)
    end

    it "add_update mention email will add to recipient" do
      mention_email = Faker::Internet.email
      post :add_update, params: { sender: @emails.first, text: "hello , #{mention_email}" }

      expect(eval(response.body)[:recipients].include?(mention_email)).to eq(true)
    end
  end


  context 'additional endpoint for create account post /account' do
    it "account won't create if just string" do
      post :create, params: { email: "hello" }, format: :json

      expect(eval(response.body)[:status]).to eq(401)
    end

    it "add success if have valid email format" do
      post :create, params: { email: Faker::Internet.email }, format: :json

      expect(eval(response.body)[:success]).to eq(true)
    end
  end

end
