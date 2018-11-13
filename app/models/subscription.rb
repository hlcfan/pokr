class Subscription < ApplicationRecord
  belongs_to :user

  DELETED = 0
  ACTIVE  = 1

  def active?
    ACTIVE == self.status
  end
end
