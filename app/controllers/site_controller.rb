class SiteController < ApplicationController

  MONEY_BAG = "💰"
  DIAMOND   = "💎"

  def about
    render "about.#{I18n.locale}"
  end

  def faq
    render "faq.#{I18n.locale}"
  end

  def donate
    @donations = [
      { name: "Steve",   amount: print_money(400) },
      { name: "Matthew", amount: print_money(193) },
      { name: "Noah",    amount: print_money(53) },
      { name: "Renee",   amount: print_money(14) },
      { name: "Cici",   amount: print_money(8) },
      { name: "Kevin",   amount: print_money(8) }
    ]

    render "donate.#{I18n.locale}"
  end

  def apps
    redirect_to :extensions, :status => 301
  end

  def pricing_page
  end

  def extensions
  end

  private

  RATIO = 50

  def print_money amount
    diamonds = amount / RATIO
    money_bags = amount % RATIO

    "#{DIAMOND*diamonds}#{MONEY_BAG*money_bags}"
  end

end
