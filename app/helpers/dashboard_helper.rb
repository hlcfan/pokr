module DashboardHelper

  def show_story_link link
    if link =~ /\A#{URI::regexp(['http', 'https'])}\z/
      link
    else
      "javascript:;"
    end
  end

end