require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "GET #show" do
    before do
      controller.append_view_path("spec/fixtures")
    end

    it "renders post if post exists" do
      allow(controller).to receive(:base_dir) { "spec/fixtures/post.html.erb" }
      allow(controller).to receive(:relative_posts_path) { "post" }
      get :show, params: { id: "post" }
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