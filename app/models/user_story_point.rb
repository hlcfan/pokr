class UserStoryPoint < ApplicationRecord

  belongs_to :user
  belongs_to :story

  def self.vote user_id, story_id, points
    user_point = UserStoryPoint.find_or_initialize_by user_id: user_id, story_id: story_id
    if user_point.update points: points
      yield user_point
    end
  end

end
