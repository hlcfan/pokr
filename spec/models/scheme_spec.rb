require 'rails_helper'

RSpec.describe Scheme, type: :model do
  subject(:scheme) { Scheme.new }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:points) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "#slug!" do
    it "generates slug before creation" do
      room = Scheme.create(name: "test slug", user_id: 1, points: ["2", "3"])
      expect(room.slug).to eq "test-slug"
    end
  end

  describe ".default_schemes" do
    it "returns default schemes" do
      expect(Scheme.default_schemes).to eq({
        "fibonacci" => %w(0 1 2 3 5 8 13 20 40 100 ? coffee),
        "0-8"       => %w(0 1 2 3 4 5 6 7 8 ? coffee),
        "XS-XXL"    => %w(XS S M L XL XXL ? coffee),
        "hours"     => %w(0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 ? coffee)
      })
    end
  end

  describe ".find_scheme" do
    it "returns one of the default scheme if it's default scheme" do
      expect(Scheme.find_scheme("fibonacci")).to eq(%w(0 1 2 3 5 8 13 20 40 100 ? coffee))
    end

    it "returns user created scheme if it's not default scheme" do
      scheme.user_id = 1
      scheme.points = ["1", "2", "3"]
      scheme.name = "sample scheme"
      scheme.save!
      expect(Scheme.find_scheme("sample-scheme")).to eq(["1", "2", "3"])
    end
  end

  describe ".schemes_of" do
    it "returns specific user's schemes" do
      scheme.user_id = 1
      scheme.points = ["1", "2", "3"]
      scheme.name = "sample scheme"
      scheme.save!
      expect(Scheme.schemes_of(1)["sample scheme"]).to eq(["1", "2", "3"])
    end
  end
end
