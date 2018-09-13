require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#title" do
    it "populates page title" do
      helper.title("this")
      expect(helper.content_for(:title)).to eq "this"
    end
  end

  describe "#description" do
    it "populates page description" do
      desc = "this" * 50
      helper.description(desc)
      expect(helper.content_for(:description_meta_content)).to eq "#{desc[0,157]}..."
    end
  end

  describe "#default_description" do
    it "returns default description" do
      expect(helper.default_description).to eq "Pokrex is an easy, efficient planning poker (a.k.a. scrum poker or pointing poker) for agile/scrum teams."
    end
  end

  describe "#flash_messages" do
    [:notice, :success, :alert, :error].each do |name|
      it "returns flash messages with style" do
        flash[name]= "flash #{name.to_s} message"
        message = capture { helper.flash_messages }
        expect(message).to match(/.*#{name}.*/)
      end
    end
  end

  describe "#is_mobile_request?" do
    it "returns true if the request comes from a mobile device" do
      mobile_user_agent = "Mozilla/5.0(iPhone;U;CPUiPhoneOS4_0likeMacOSX;en-us)AppleWebKit/532.9(KHTML,likeGecko)Version/4.0.5Mobile/8A293Safari/6531.22.7"
      @request.user_agent = mobile_user_agent

      expect(helper.is_mobile_request?).to be_truthy
    end

    it "returns false if the request does not come from a mobile device" do
      non_mobile_user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
      @request.user_agent = non_mobile_user_agent

      expect(helper.is_mobile_request?).to be_falsey
    end
  end

  describe "#plan_price" do
    it "returns 4 times of the price if zh-cn" do
      allow(I18n).to receive(:locale) { :"zh-CN" }
      expect(plan_price(5)).to eq(20)
    end

    it "returns the price if other locales" do
      allow(I18n).to receive(:locale) { :en }
      expect(plan_price(5)).to eq(5)
    end
  end
end
