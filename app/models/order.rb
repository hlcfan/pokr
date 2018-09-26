class Order < ApplicationRecord

  INITIAL = 0
  FAILED  = 1
  SUCCESS = 2

  belongs_to :user

end
