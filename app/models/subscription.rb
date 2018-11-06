class Subscription < ApplicationRecord
  belongs_to :user

  DELETED = 0
  ACTIVE  = 1
end
