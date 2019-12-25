require 'rails_helper'

RSpec.describe Retro, type: :model do
  subject(:retro) { Retro.new }

  describe "#validation" do
    it "is invalid if no name specified" do
      expect(subject.valid?).to be false
      expect(subject.errors[:name]).to include "can't be blank"
      subject.name = "name"
      expect(subject.valid?).to be true
      expect(subject.errors).to be_empty
    end
  end

  describe ".new_from_form" do
    before do
      RetroScheme.default.each do |scheme|
        scheme.save
      end
    end

    it "initializes a retro from form submission" do
      params = {
        name: "test",
        scheme_uid: "msg",
      }
      retro = Retro.new_from_form(params)
      expect(retro.retro_scheme_id).to eq -2

      params[:scheme_uid] = "ooooo-mmmmm-gggg"
      retro = Retro.new_from_form(params)
      expect(retro.retro_scheme_id).to eq -1
    end
  end
end
