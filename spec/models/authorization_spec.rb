require 'rails_helper'

RSpec.describe Authorization, type: :model do

  describe ".find_for_oauth" do
    before do
      AUTH = Struct.new(:uid, :provider)
    end

    it "finds authorization" do
      authorization = Authorization.create(uid: "12345", provider: "weibo", user_id: 1)
      auth = AUTH.new("12345", "weibo")

      expect(Authorization.find_for_oauth(auth)).to eq authorization
    end

    it "creates Authorization if no record found" do
      auth = AUTH.new("12345", "weibo")
      authorization = Authorization.find_for_oauth(auth)

      expect(authorization.uid).to eq "12345"
      expect(authorization.provider).to eq "weibo"
    end
  end
end
