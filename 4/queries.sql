-- Кількість ігор у каталозі
SELECT COUNT(*) AS total_games
FROM game;
-- Кількість покупок всього у магазині
SELECT COUNT(*) AS total_purchases
FROM purchase;

-- Кількість разів гру id=2 було куплено
SELECT COUNT(*) AS purchases
FROM purchase
WHERE game_id = 2;

-- Кількість ігор у гравця id=2
SELECT COUNT(*) AS purchases
FROM purchase
WHERE credential_id = 2;

-- Мінімальна, середня та максимальна вартості ігор
SELECT MIN(price::numeric) AS minium,
AVG(price::numeric) AS average,
MAX(price::numeric) AS minium
FROM game;
--Можна використати для фільтру ігор за ціною: слайдер від мінімальної до максимальної, а дефолт - середня

-- Кількість ігор у кожного користувача магазину
SELECT COUNT(*) AS purchases
FROM purchase
GROUP BY credential_id;

-- Поєднання ім'я профілю та назви гри через покупку
SELECT g.title, pf.name
FROM game g
JOIN purchase p on p.game_id = g.id
JOIN profile pf on p.credential_id = pf.credential_id

-- Поєднання назв ігор, імен профілів і відгуків про гру
SELECT g.title, pf.name, r.words
FROM game g
JOIN review r on r.game_id = g.id
JOIN profile pf on r.profile_id = pf.id;

-- Лише ігри без відгуків 
SELECT g.title, r
FROM game g
LEFT JOIN review r ON g.id = r.game_id
WHERE r is NULL;

-- Ігри дорожче середнього
SELECT * FROM game
WHERE price::numeric > (SELECT AVG(price::numeric) FROM game);

-- Користувачи що залишали якісь відгуки
SELECT name
FROM profile WHERE (SELECT COUNT(*) FROM review) > 0;

-- Ігри де досягнень більше за 1
SELECT g.title, a.title FROM game g
JOIN achievement a ON a.game_id = g.id
WHERE (SELECT COUNT(*) FROM achievement) > 1

