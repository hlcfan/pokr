desc "Update/generate uid"
task update_uid: :environment do
  User.where(uid: nil).find_each do |user|
    user.update_attribute :uid, SecureRandom.rand(36**8).to_s(36)
    puts "User #{user.email} updated."
  end


end