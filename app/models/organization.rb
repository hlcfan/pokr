class Organization < ApplicationRecord

  include UidGeneration

  validates_presence_of :name

  belongs_to :creator, class_name: "User", foreign_key: :created_by

  has_many :user_organizations
  has_many :users, through: :user_organizations
end
