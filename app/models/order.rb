class Order < ApplicationRecord

  INITIAL = 0
  FAILED  = 1
  SUCCESS = 2

  belongs_to :user

  def friendly_status
    {
      INITIAL =>  "Canceled",
      FAILED =>   "Failed",
      SUCCESS =>  "Success"
    }.fetch(status, "Unknown")
  end

end
