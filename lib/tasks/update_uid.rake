desc "Generate uid"
task generate_uid: :environment do
  User.where(uid: nil).find_each do |user|
    user.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "User #{user.email} updated."
  end

  Story.where(uid: nil).find_each do |story|
    story.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "Story #{story.link} updated."
  end

  UserRoom.where(uid: nil).find_each do |user_room|
    user_room.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "UserRoom #{user_room.id} updated."
  end

  UserStoryPoint.where(uid: nil).find_each do |user_story_point|
    user_story_point.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "UserStoryPoint #{user_story_point.id} updated."
  end

  Scheme.where(uid: nil).find_each do |scheme|
    scheme.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "Scheme #{scheme.id} updated."
  end

  Room.where(uid: nil).find_each do |room|
    room.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "Room #{room.slug} updated."
  end

  puts "Done."
end
