class SiteController < ApplicationController

  MONEY_BAG = "💰"

  def about
    render "about.#{I18n.locale}"
  end

  def faq
    render "faq.#{I18n.locale}"
  end

  def donate
    @donations = [
      { name: "Matthew", amount: MONEY_BAG*66 },
      { name: "Noah",    amount: MONEY_BAG*40 },
      { name: "Renee",   amount: MONEY_BAG*5 },
      { name: "Kevin",   amount: MONEY_BAG*8 }
    ]

    render "donate.#{I18n.locale}"
  end

  def apps

  end

end
