require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { Post.new("spec/fixtures/post.html.erb") }

  describe "#title" do
    it "returns post title from meta info block" do
      expect(post.title).to eq("Why grooming session is important?")
    end
  end

  describe "#date" do
    it "returns post publish date from meta info block" do
      expect(post.date).to eq("2018-03-15")
    end
  end

  describe "#defacto_file_name" do
    it "returns post defacto file name" do
      post = Post.new("posts/pages/post.html.erb")
      expect(post.defacto_file_name).to eq("post")
    end
  end

  describe "#==" do
    it "returns true if same file path" do
      other_post = Post.new("spec/fixtures/post.html.erb")
      expect(post).to eq(other_post)
    end
  end
end