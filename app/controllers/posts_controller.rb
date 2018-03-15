class PostsController < ApplicationController

  layout "post"

  def show
    if valid_page?
      render template: "posts/#{params[:id]}"
    else
      render "errors/not_found", layout: "application"
    end
  end

  private

  def valid_page?
    File.exist?(Rails.root.join("app", "views", "posts", "#{params[:id]}.html.erb"))
  end

end