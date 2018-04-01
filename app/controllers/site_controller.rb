class SiteController < ApplicationController

  def about
    render "about.#{I18n.locale}"
  end

  def faq
    render "faq.#{I18n.locale}"
  end

  def donate
    render "donate.#{I18n.locale}"
  end

end
