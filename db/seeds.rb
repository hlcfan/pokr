# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_lisa = User.create(name: 'Lisa', role: 0)
user_alex = User.create(name: 'Alex', role: 1)

room = Room.create(name: 'Grooooming', status: 1)

user_room1 = UserRoom.create user_id: 1, room_id: 1
user_room2 = UserRoom.create user_id: 2, room_id: 1

story1 = Story.create room_id: 1, link: 'http://baidu.com', desc: 'his file should contain all the record creation needed to seed the database with its default values.'
story1 = Story.create room_id: 1, link: 'http://google.com', desc: 'The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).'

user_room_story1 = UserStoryPoint.create user_id: 1, story_id: 1, points: 8
user_room_story2 = UserStoryPoint.create user_id: 2, story_id: 1, points: 13