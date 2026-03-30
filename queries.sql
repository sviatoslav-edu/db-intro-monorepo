BEGIN;
ALTER TABLE purchase
ADD CONSTRAINT unique_purchase UNIQUE (credential_id, game_id);

ALTER TABLE review
ADD CONSTRAINT unique_review UNIQUE (profile_id, game_id);

ALTER TABLE profile_achievement
ALTER COLUMN achievement_id TYPE INTEGER,
ALTER COLUMN profile_id TYPE INTEGER;

ALTER TABLE game_media
ALTER COLUMN game_id TYPE INTEGER,
ALTER COLUMN media_id TYPE INTEGER;

ALTER TABLE game_tag
ALTER COLUMN game_id TYPE INTEGER,
ALTER COLUMN tag_id TYPE INTEGER;
COMMIT;
