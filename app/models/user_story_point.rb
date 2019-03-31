class UserStoryPoint < ApplicationRecord

  include UidGeneration
  belongs_to :user
  belongs_to :story

  def self.vote user_id, story_id, points, comment=nil
    story = Story.find_by(uid: story_id)
    user_point = UserStoryPoint.find_or_initialize_by user_id: user_id, story_id: story.id
    user_point.comment = comment if comment.present?

    if user_point.update points: points
      user_point
    end
  end

end
