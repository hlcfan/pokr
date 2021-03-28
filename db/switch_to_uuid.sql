-- Add uuid column
ALTER TABLE authorizations
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE authorizations
ADD COLUMN user_uuid uuid default gen_random_uuid() not null;

ALTER TABLE orders
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE orders
ADD COLUMN user_uuid uuid default gen_random_uuid() not null;

ALTER TABLE rooms
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE rooms
ADD COLUMN created_by_uuid uuid default gen_random_uuid() not null;

ALTER TABLE schemes
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE schemes
ADD COLUMN user_uuid uuid default gen_random_uuid() not null;

ALTER TABLE stories
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE stories
ADD COLUMN room_uuid uuid default gen_random_uuid() not null;

ALTER TABLE subscriptions
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE subscriptions
ADD COLUMN user_uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_rooms
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_rooms
ADD COLUMN user_uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_rooms
ADD COLUMN room_uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_story_points
ADD COLUMN uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_story_points
ADD COLUMN user_uuid uuid default gen_random_uuid() not null;

ALTER TABLE user_story_points
ADD COLUMN story_uuid uuid default gen_random_uuid() not null;

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
user_uuid = u.uuid,
room_uuid = r.uuid
FROM users u, rooms r
WHERE ur.room_id = r.id AND ur.user_id = u.id;

UPDATE user_story_points usp
SET
user_uuid = u.uuid,
story_uuid = s.uuid
FROM users u, stories s
WHERE usp.story_id = s.id AND usp.user_id = u.id;

UPDATE pg_search_documents sd
SET
uuid = s.id
FROM stories s
WHERE searchable_type = 'Story' AND s.id = sd.searchable_id;

UPDATE pg_search_documents sd
SET
uuid = r.id
FROM rooms r
WHERE searchable_type = 'Room' AND r.id = sd.searchable_id;

-- Rename id to integer_id
-- Rename uuid to id
ALTER TABLE authorizations
RENAME COLUMN id TO integer_id;

ALTER TABLE authorizations
RENAME COLUMN uuid TO id;

ALTER TABLE orders
RENAME COLUMN id TO integer_id;

ALTER TABLE orders
RENAME COLUMN uuid TO id;

ALTER TABLE rooms
RENAME COLUMN id TO integer_id;

ALTER TABLE rooms
RENAME COLUMN uuid TO id;

ALTER TABLE rooms
RENAME COLUMN created_by TO integer_created_by;

ALTER TABLE rooms
RENAME COLUMN created_by_uuid TO created_by;

ALTER TABLE schemes
RENAME COLUMN id TO integer_id;

ALTER TABLE schemes
RENAME COLUMN uuid TO id;

ALTER TABLE stories
RENAME COLUMN id TO integer_id;

ALTER TABLE stories
RENAME COLUMN uuid TO id;

ALTER TABLE stories
RENAME COLUMN room_id TO integer_room_id;

ALTER TABLE stories
RENAME COLUMN room_uuid TO room_id;

ALTER TABLE subscriptions
RENAME COLUMN id TO integer_id;

ALTER TABLE subscriptions
RENAME COLUMN uuid TO id;

ALTER TABLE user_rooms
RENAME COLUMN id TO integer_id;

ALTER TABLE user_rooms
RENAME COLUMN uuid TO id;

ALTER TABLE user_rooms
RENAME COLUMN uuid TO id;

ALTER TABLE user_rooms
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE user_rooms
RENAME COLUMN user_uuid TO user_id;

ALTER TABLE user_rooms
RENAME COLUMN room_id TO integer_room_id;

ALTER TABLE user_rooms
RENAME COLUMN room_uuid TO room_id;

ALTER TABLE user_story_points
RENAME COLUMN id TO integer_id;

ALTER TABLE user_story_points
RENAME COLUMN uuid TO id;

ALTER TABLE user_story_points
RENAME COLUMN story_id TO integer_story_id;

ALTER TABLE user_story_points
RENAME COLUMN story_uuid TO story_id;

ALTER TABLE user_story_points
RENAME COLUMN user_id TO integer_user_id;

ALTER TABLE user_story_points
RENAME COLUMN user_uuid TO user_id;

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

ALTER TABLE orders DROP COLUMN integer_id;
ALTER TABLE orders ADD PRIMARY KEY (id);

ALTER TABLE pg_search_documents DROP COLUMN integer_id;
ALTER TABLE pg_search_documents ADD PRIMARY KEY (id);

ALTER TABLE rooms DROP COLUMN integer_id;
ALTER TABLE rooms ADD PRIMARY KEY (id);

ALTER TABLE rooms DROP COLUMN created_by;

ALTER TABLE schemes DROP COLUMN integer_id;
ALTER TABLE schemes ADD PRIMARY KEY (id);

ALTER TABLE stories DROP COLUMN integer_id;
ALTER TABLE stories ADD PRIMARY KEY (id);

ALTER TABLE stories DROP COLUMN integer_room_id;

ALTER TABLE subscriptions DROP COLUMN integer_id;
ALTER TABLE subscriptions ADD PRIMARY KEY (id);

ALTER TABLE user_rooms DROP COLUMN integer_id;
ALTER TABLE user_rooms ADD PRIMARY KEY (id);

ALTER TABLE user_story_points DROP COLUMN integer_id;
ALTER TABLE user_story_points ADD PRIMARY KEY (id);

ALTER TABLE users DROP COLUMN integer_id;
ALTER TABLE users ADD PRIMARY KEY (id);
