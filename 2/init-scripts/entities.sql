--Перевіряємо чи користувач придбав гру
CREATE FUNCTION public.check_purchase_by_profile_and_game(IN p_id integer, IN g_id integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    
AS $BODY$
BEGIN
RETURN EXISTS (
    SELECT 1
    FROM purchase
    WHERE credential_id = (
        SELECT credential_id
        FROM profile
        WHERE id = p_id
    )
    AND game_id = g_id
);
END;
$BODY$;

ALTER FUNCTION public.check_purchase_by_profile_and_game(integer, integer)
    OWNER TO postgres;

--Перевіряємо чи користувач придбав гру
CREATE FUNCTION public.check_purchase_by_profile_and_achievement(IN p_id integer, IN a_id integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    
AS $BODY$
BEGIN
RETURN EXISTS (
    SELECT 1
    FROM purchase
    WHERE credential_id = (
        SELECT credential_id
        FROM profile
        WHERE id = p_id
    )
    AND game_id = (
      SELECT game_id
      FROM achievement
      WHERE id = a_id
    )
);
END;
$BODY$;

ALTER FUNCTION public.check_purchase_by_profile_and_achievement(integer, integer)
    OWNER TO postgres;

--Дані входу
CREATE TABLE credential (
  id SERIAL PRIMARY KEY,
  login VARCHAR(12) NOT NULL UNIQUE, --Можна було б і VARCHAR(12) NOT NULL CHECK (login LIKE '[A-z0-9_]'), але якщо користувач хоче мати "😀-Gaming", то чого б і ні :)
  email VARCHAR(256) NOT NULL CHECK(email LIKE '%@%') UNIQUE, -- Можна додати ще способи перевірки пошти, але врешті-решт лише email-verification із лиштом на пошту може дійсно перевірити валідність пошти
  password_hash VARCHAR(100) NOT NULL
);

--Медіа
CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  data BYTEA NOT NULL --Данні файлу
);

--Студія розробки або видатництва
CREATE TABLE studio (
  id SERIAL PRIMARY KEY,
  logo_id INTEGER REFERENCES media(id) ON DELETE SET NULL, --Посилання на лого студії
  title VARCHAR(32) NOT NULL, --Назва студії, обов'язкова
  about VARCHAR(256) --Про студію
);

--Гра
CREATE TABLE game (
  id SERIAL PRIMARY KEY,
  studio_id INTEGER REFERENCES studio(id) ON DELETE CASCADE NOT NULL, --Студія розробки, обов'язково
  publisher_id INTEGER REFERENCES studio(id) ON DELETE CASCADE NOT NULL, --Студія видатництва, обов'язково
  title VARCHAR(32) NOT NULL, --Нзава гри, обов'язково
  price MONEY CHECK(price > '0'::money),
  data BYTEA NOT NULL,
  description VARCHAR(255) --Опис гри
);

--Профіль
CREATE TABLE profile (
  id SERIAL PRIMARY KEY,
  credential_id INTEGER REFERENCES credential(id) ON DELETE CASCADE NOT NULL UNIQUE, --Дані входу для профілю
  pfp_id INTEGER REFERENCES media(id) ON DELETE SET NULL, --Посилання на зображення аватарки
  name VARCHAR(32) NOT NULL, --Ім'я профілю, обов'язкове
  about VARCHAR(256), --Про себе
  created_date DATE DEFAULT CURRENT_DATE NOT NULL --Дата створення
);

--Проміжна таблиця для зв'язку багато до багатьох
CREATE TABLE game_media (
  id SERIAL PRIMARY KEY,
  game_id SERIAL REFERENCES game(id) ON DELETE CASCADE NOT NULL, --Посилання на гру
  media_id SERIAL REFERENCES media(id) ON DELETE CASCADE NOT NULL --Послиання на медіа
);

--Тегри гри(Жанри, особливості)
CREATE TABLE tag (
  id SERIAL PRIMARY KEY,
  name VARCHAR(10) NOT NULL UNIQUE --Тег, унікальний
);

--Проміжна таблиця для зв'язку багато до багатьох
CREATE TABLE game_tag (
  id SERIAL PRIMARY KEY,
  game_id SERIAL REFERENCES game(id) ON DELETE CASCADE NOT NULL, --Посилання на гру
  tag_id SERIAL REFERENCES tag(id) ON DELETE CASCADE NOT NULL, --Поислання на тег
  UNIQUE(game_id, tag_id)
);

--Відгук
CREATE TABLE review (
  id SERIAL PRIMARY KEY,
  profile_id INTEGER REFERENCES profile(id) ON DELETE CASCADE NOT NULL, --Посилання на профіль автору, обов'язково
  game_id INTEGER REFERENCES game(id) ON DELETE CASCADE NOT NULL, --Посилання на гру про яку відгук, обов'язково
  recommend BOOLEAN NOT NULL, --Чи рекомендує, обов'язково
  words VARCHAR(255), --Слова відгуку
  CHECK (check_purchase_by_profile_and_game(profile_id, game_id))
);

--Покупка
CREATE TABLE purchase (
  id SERIAL PRIMARY KEY,
  credential_id INTEGER REFERENCES credential(id) ON DELETE CASCADE NOT NULL, --Дані користувача що купив гру, обов'язково
  game_id INTEGER REFERENCES game(id) ON DELETE CASCADE NOT NULL, --Гру що купив, обов'язково
  price MONEY NOT NULL, --За скільки придбва, обов'язково
  created_date DATE DEFAULT CURRENT_DATE NOT NULL --Дата покупки
);

--Додатковий контент
CREATE TABLE content (
  id SERIAL PRIMARY KEY,
  profile_id INTEGER REFERENCES profile(id) ON DELETE CASCADE NOT NULL,
  game_id INTEGER REFERENCES game(id) ON DELETE CASCADE NOT NULL,
  title VARCHAR(32) NOT NULL,
  description VARCHAR(256),
  data BYTEA NOT NULL,
  CHECK (check_purchase_by_profile_and_game(profile_id, game_id))
);

CREATE TABLE signature (
  id SERIAL PRIMARY KEY,
  profile_id INTEGER REFERENCES profile(id) ON DELETE CASCADE NOT NULL,
  author_id INTEGER REFERENCES profile(id) ON DELETE CASCADE NOT NULL CHECK (author_id <> profile_id),
  signature VARCHAR(256) NOT NULL,
  created_date DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE achievement (
  id SERIAL PRIMARY KEY,
  game_id INTEGER REFERENCES game(id) ON DELETE CASCADE NOT NULL,
  logo_id INTEGER REFERENCES media(id) ON DELETE SET NULL,
  title VARCHAR(32) NOT NULL,
  description VARCHAR(255)
);

CREATE TABLE profile_achievement (
  id SERIAL PRIMARY KEY,
  profile_id SERIAL REFERENCES profile(id) ON DELETE CASCADE NOT NULL,
  achievement_id SERIAL REFERENCES achievement(id) ON DELETE CASCADE NOT NULL,
  CHECK (check_purchase_by_profile_and_achievement(profile_id, achievement_id)),
  UNIQUE (profile_id, achievement_id)
);

CREATE EXTENSION pgcrypto;


INSERT INTO credential (id, login, email, password_hash)
VALUES
  (1, 'user001', 'user001@edu.kpi.ua', crypt('user001password', gen_salt('bf', 8))),
  (2, 'supergamer', 'nagibator228@gmail.com', crypt('qwerty', gen_salt('bf', 8))),
  (3, 'bebronuh', 'bebronuh@gmail.com', crypt('bebra', gen_salt('bf', 8))),
  (4, 'ZabinGaming', 'zabin@edu.kpi.ua', crypt('ILoveComputers', gen_salt('bf', 8)));


INSERT INTO profile (id, credential_id, name, about)
VALUES
  (1, 1, 'User001', 'I am first user of this AMAZING platform'),
  (2, 2, 'Super Gamer', 'TRYHARD'),
  (3, 3, 'BEST PLAYER THAT EVER LIVED!!!', 'I AM THE THE THE BEST PLAYER, I WILL DOMINATE YOU IN EVERY GAME POSSIBLE!!!'),
  (4, 4, 'Valeriy Zabin', '110010101001010100101010101010');

INSERT INTO studio (id, title)
VALUES
  (1, 'KPI GAMES'),
  (2, 'Woman Slayer Production'),
  (3, 'noname indi dev');

SET bytea_output = 'hex';

INSERT INTO game (id, studio_id, publisher_id, title, price, data)
VALUES
  (1, 1, 1, 'Vtecha vid Zabina', 100, '\x00000000'::bytea),
  (2, 2, 2, 'Woman Slayer', 100, '\x00000000'::bytea),
  (3, 3, 3, 'Furry Roommate 1', 200, '\x00000000'::bytea),
  (4, 3, 3, 'Furry Roommate 2', 300, '\x00000000'::bytea);

INSERT INTO tag (id, name)
VALUES
  (1, 'Shooter'),
  (2, 'Topdown'),
  (3, '2D');

INSERT INTO game_tag(id, game_id, tag_id)
VALUES
  (1, 2, 1),
  (2, 2, 2),
  (3, 2, 3);

INSERT INTO purchase(id, credential_id, game_id, price)
VALUES
  (1, 1, 2, 100),
  (2, 2, 2, 100),
  (3, 3, 2, 100),
  (4, 4, 2, 100);

INSERT INTO review (id, profile_id, game_id, recommend, words)
VALUES
  (1, 1, 2, TRUE, 'Ok, NOW this is EPIC!!'),
  (2, 2, 2, TRUE, 'WOW!!!'),
  (3, 3, 2, TRUE, 'I NEEED SEQUELLL!!!'),
  (4, 4, 2, TRUE, 'neymovirno');

INSERT INTO signature (id, profile_id, author_id, signature)
VALUES
  (1, 1, 2, 'Sign 1'),
  (2, 1, 2, 'Sign 2'),
  (3, 3, 2, 'Sign 3');

INSERT INTO achievement (id, game_id, title, description)
VALUES
  (1, 2, 'First time in the game', 'Player started game for the first time'),
  (2, 2, 'Second time in the game', 'Player started game for the second time'),
  (3, 2, 'Third time in the game', 'Player started game for the third time');

INSERT INTO profile_achievement (id, profile_id, achievement_id)
VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 1, 3);
