class PostsController < ApplicationController

  layout "post"

  def show
    if valid_page?
      render template: "posts/pages/#{params[:id]}"
    else
      render "errors/not_found", layout: "application"
    end
  end

  def index
    post_paths = Dir.glob base_dir("*.html.erb")
    @posts = post_paths.map do |post|
      Post.new(post)
    end
  end

  private

  def valid_page?
    File.exist?(base_dir("#{params[:id]}.html.erb"))
  end

  def base_dir pattern
    Rails.root.join("app", "views", "posts", "pages", pattern)
  end

end