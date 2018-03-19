require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "GET #show" do
    it "renders post if post exists" do
      get :show, params: { id: "grooming-session-is-important" }
      expect(response.status).to eq(200)
    end

    it "renders 404 page if post not exists" do
      allow(controller).to receive(:post_exists?) { false }
      get :show, params: { id: "invalid-post" }
      expect(response.status).to eq(404)
    end
  end

  describe "#index" do
    it "assigns @posts" do
      allow(controller).to receive(:base_dir) { "spec/fixtures/*.html.erb" }
      get :index
      expect(response.status).to eq(200)
      expect(assigns(:posts)[0]).to eq(Post.new("spec/fixtures/post.html.erb"))
    end
  end
end