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
      expect(helper.default_description).to eq "Pokrex, is an easy, efficient planning poker, scrum poker or pointing poker for agile/scrum teams."
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
end
