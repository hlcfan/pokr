class Scheme < ApplicationRecord

  belongs_to :user

  validates_presence_of :name, :points
end
