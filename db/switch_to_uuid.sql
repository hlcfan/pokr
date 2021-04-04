-- Add uuid column

ALTER TABLE authorizations
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE authorizations
ADD COLUMN user_uuid uuid;

ALTER TABLE orders
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE orders
ADD COLUMN user_uuid uuid;

ALTER TABLE rooms
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE rooms
ADD COLUMN created_by_uuid uuid;

ALTER TABLE schemes
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE schemes
ADD COLUMN user_uuid uuid;

ALTER TABLE stories
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE stories
ADD COLUMN room_uuid uuid;

ALTER TABLE subscriptions
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE subscriptions
ADD COLUMN user_uuid uuid;

ALTER TABLE user_rooms
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_rooms
ADD COLUMN user_uuid uuid;

ALTER TABLE user_rooms
ADD COLUMN room_uuid uuid;

ALTER TABLE user_story_points
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_story_points
ADD COLUMN user_uuid uuid;

ALTER TABLE user_story_points
ADD COLUMN story_uuid uuid;

ALTER TABLE users
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE pg_search_documents
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE pg_search_documents
ADD COLUMN searchable_uuid uuid;

-- Update foreign keys

UPDATE authorizations a
SET user_uuid = u.uuid
FROM users u
WHERE a.user_id = u.id;

UPDATE orders o
SET user_uuid = u.uuid
FROM users u
WHERE o.user_id = u.id;

UPDATE rooms r
SET created_by_uuid = u.uuid
FROM users u
WHERE r.created_by = u.id;

UPDATE schemes s
SET user_uuid = u.uuid
FROM users u
WHERE s.user_id = u.id;

UPDATE stories s
SET room_uuid = r.uuid
FROM rooms r
WHERE s.room_id = r.id;

UPDATE subscriptions s
SET user_uuid = u.uuid
FROM users u
WHERE s.user_id = u.id;

UPDATE user_rooms ur
SET
user_uuid = u.uuid
FROM users u
WHERE ur.user_id = u.id;

UPDATE user_rooms ur
SET
room_uuid = r.uuid
FROM rooms r
WHERE ur.room_id = r.id;

UPDATE user_story_points usp
SET
user_uuid = u.uuid
FROM users u
WHERE usp.user_id = u.id;

UPDATE user_story_points usp
SET
story_uuid = s.uuid
FROM stories s
WHERE usp.story_id = s.id;

UPDATE pg_search_documents sd
SET
uuid = s.uuid
FROM stories s
WHERE searchable_type = 'Story' AND s.id = sd.searchable_id;

UPDATE pg_search_documents sd
SET
uuid = r.uuid
FROM rooms r
WHERE searchable_type = 'Room' AND r.id = sd.searchable_id;

-- Rename id to integer_id
-- Rename uuid to id

ALTER TABLE authorizations
RENAME COLUMN id TO integer_id;

ALTER TABLE authorizations
RENAME COLUMN uuid TO id;

ALTER TABLE authorizations
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE authorizations
RENAME COLUMN user_uuid TO user_id;

--ALTER TABLE authorizations
--ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE orders
RENAME COLUMN id TO integer_id;

ALTER TABLE orders
RENAME COLUMN uuid TO id;

ALTER TABLE orders
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE orders
RENAME COLUMN user_uuid TO user_id;

ALTER TABLE orders
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE rooms
RENAME COLUMN id TO integer_id;

ALTER TABLE rooms
RENAME COLUMN uuid TO id;

ALTER TABLE rooms
RENAME COLUMN created_by TO integer_created_by;

ALTER TABLE rooms
RENAME COLUMN created_by_uuid TO created_by;

--ALTER TABLE rooms
--ALTER COLUMN created_by SET NOT NULL;

ALTER TABLE schemes
RENAME COLUMN id TO integer_id;

ALTER TABLE schemes
RENAME COLUMN uuid TO id;

ALTER TABLE schemes
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE schemes
RENAME COLUMN user_uuid TO user_id;

ALTER TABLE schemes
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE stories
RENAME COLUMN id TO integer_id;

ALTER TABLE stories
RENAME COLUMN uuid TO id;

ALTER TABLE stories
RENAME COLUMN room_id TO integer_room_id;

ALTER TABLE stories
RENAME COLUMN room_uuid TO room_id;

ALTER TABLE stories
ALTER COLUMN room_id SET NOT NULL;

ALTER TABLE subscriptions
RENAME COLUMN id TO integer_id;

ALTER TABLE subscriptions
RENAME COLUMN uuid TO id;

ALTER TABLE subscriptions
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE subscriptions
RENAME COLUMN user_uuid TO user_id;

ALTER TABLE subscriptions
ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE user_rooms
RENAME COLUMN id TO integer_id;

ALTER TABLE user_rooms
RENAME COLUMN uuid TO id;

ALTER TABLE user_rooms
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE user_rooms
RENAME COLUMN user_uuid TO user_id;

--ALTER TABLE user_rooms
--ALTER COLUMN user_id SET NOT NULL; --TODO: remove records without user_id and room_id

ALTER TABLE user_rooms
RENAME COLUMN room_id TO integer_room_id;

ALTER TABLE user_rooms
RENAME COLUMN room_uuid TO room_id;

--ALTER TABLE user_rooms
--ALTER COLUMN room_id SET NOT NULL; --TODO: remove records without user_id and room_id

ALTER TABLE user_story_points
RENAME COLUMN id TO integer_id;

ALTER TABLE user_story_points
RENAME COLUMN uuid TO id;

ALTER TABLE user_story_points
RENAME COLUMN story_id TO integer_story_id;

ALTER TABLE user_story_points
RENAME COLUMN story_uuid TO story_id;

--ALTER TABLE user_story_points
--ALTER COLUMN story_id SET NOT NULL;

--select * from user_story_points where story_id is null;

ALTER TABLE user_story_points
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE user_story_points
RENAME COLUMN user_uuid TO user_id;

--ALTER TABLE user_story_points
--ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE users
RENAME COLUMN id TO integer_id;

ALTER TABLE users
RENAME COLUMN uuid TO id;

ALTER TABLE pg_search_documents
RENAME COLUMN id TO integer_id;

ALTER TABLE pg_search_documents
RENAME COLUMN uuid TO id;

ALTER TABLE pg_search_documents
RENAME COLUMN searchable_id TO searchable_integer_id;

ALTER TABLE pg_search_documents
RENAME COLUMN searchable_uuid TO searchable_id;

-- Update Primary key

ALTER TABLE authorizations DROP COLUMN integer_id;
ALTER TABLE authorizations ADD PRIMARY KEY (id);
ALTER TABLE authorizations DROP COLUMN integer_user_id;

ALTER TABLE orders DROP COLUMN integer_id;
ALTER TABLE orders ADD PRIMARY KEY (id);
ALTER TABLE orders DROP COLUMN integer_user_id;

ALTER TABLE pg_search_documents DROP COLUMN integer_id;
ALTER TABLE pg_search_documents ADD PRIMARY KEY (id);
ALTER TABLE pg_search_documents DROP COLUMN searchable_integer_id;

ALTER TABLE rooms DROP COLUMN integer_id;
ALTER TABLE rooms ADD PRIMARY KEY (id);

ALTER TABLE rooms DROP COLUMN integer_created_by;

ALTER TABLE schemes DROP COLUMN integer_id;
ALTER TABLE schemes ADD PRIMARY KEY (id);
ALTER TABLE schemes DROP COLUMN integer_user_id;

ALTER TABLE stories DROP COLUMN integer_id;
ALTER TABLE stories ADD PRIMARY KEY (id);

ALTER TABLE stories DROP COLUMN integer_room_id;

ALTER TABLE subscriptions DROP COLUMN integer_id;
ALTER TABLE subscriptions ADD PRIMARY KEY (id);

ALTER TABLE subscriptions DROP COLUMN integer_user_id;

ALTER TABLE user_rooms DROP COLUMN integer_id;
ALTER TABLE user_rooms ADD PRIMARY KEY (id);

ALTER TABLE user_rooms DROP COLUMN integer_room_id;
ALTER TABLE user_rooms DROP COLUMN integer_user_id;

ALTER TABLE user_story_points DROP COLUMN integer_id;
ALTER TABLE user_story_points ADD PRIMARY KEY (id);

ALTER TABLE user_story_points DROP COLUMN integer_user_id;
ALTER TABLE user_story_points DROP COLUMN integer_story_id;

ALTER TABLE users DROP COLUMN integer_id;
ALTER TABLE users ADD PRIMARY KEY (id);

-- Remove existing uid

ALTER TABLE authorizations DROP COLUMN uid;
ALTER TABLE rooms DROP COLUMN uid;
ALTER TABLE schemes DROP COLUMN uid;
ALTER TABLE stories DROP COLUMN uid;
ALTER TABLE user_rooms DROP COLUMN uid;
ALTER TABLE user_story_points DROP COLUMN uid;
ALTER TABLE users DROP COLUMN uid;

-- Add index for new columns

CREATE INDEX idx_authorizations_user_id ON authorizations (user_id);
CREATE INDEX idx_orders_on_user_id ON orders (user_id);
CREATE INDEX idx_rooms_on_created_by ON rooms (created_by);
CREATE INDEX idx_schemes_on_user_id ON schemes (user_id);
CREATE INDEX idx_stories_on_user_id ON stories (room_id);
CREATE INDEX idx_subscriptions_on_user_id ON subscriptions (user_id);
CREATE UNIQUE INDEX idx_user_rooms_on_user_id_and_room_id ON user_rooms (user_id, room_id);
CREATE INDEX idx_user_rooms_on_room_id ON user_rooms (room_id);
CREATE UNIQUE INDEX idx_user_story_points_on_user_id_and_story_id ON user_story_points (user_id, story_id);
CREATE INDEX idx_user_story_points_on_story_id ON user_story_points (story_id);

--select * from user_rooms where user_uuid is null;
--select * from user_rooms where uid='f44nn3k0';
--select * from user_rooms where room_uuid is null;
--select * from user_story_points where story_id is null;
