class SiteController < ApplicationController

  def about
    render "about.#{I18n.locale}"
  end

  def faq

  end

end
