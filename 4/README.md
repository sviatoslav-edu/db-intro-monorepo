# Частина 4
_Інтернет магазин ігор (альтернатива Steam)_

## SQL запити
### Агрегаційні функції 
#### Кількість ігор у каталозі
```SQL
SELECT COUNT(*) AS total_games
FROM game;
```
<img width="1150" height="197" alt="image" src="https://github.com/user-attachments/assets/c90e7a3c-5b60-4449-913a-0423edb5be8c" />

#### Кількість покупок всього у магазині
```SQL
SELECT COUNT(*) AS total_purchases
FROM purchase;
```
<img width="1159" height="168" alt="image" src="https://github.com/user-attachments/assets/b10517aa-3807-428c-b25b-8d84e0989aae" />

#### Кількість разів гру id=2 було куплено
```SQL
SELECT COUNT(*) AS purchases
FROM purchase
WHERE game_id = 2;
```
<img width="1151" height="168" alt="image" src="https://github.com/user-attachments/assets/58c18935-04e6-4be5-8487-c023c427a3cf" />

#### Кількість ігор у гравця id=2
```SQL
SELECT COUNT(*) AS purchases
FROM purchase
WHERE credential_id = 2;
```
<img width="408" height="105" alt="image" src="https://github.com/user-attachments/assets/f7a4b7dd-365b-44d5-9402-f7f996c61e6e" />

#### Мінімальна, середня та максимальна вартості ігор
```SQL
SELECT MIN(price::numeric) AS minium,
AVG(price::numeric) AS average,
MAX(price::numeric) AS minium
FROM game;
--Можна використати для фільтру ігор за ціною: слайдер від мінімальної до максимальної, а дефолт - середня
```
<img width="1155" height="123" alt="image" src="https://github.com/user-attachments/assets/59d35f28-33a2-4b84-b18f-c104ce7a303f" />


#### Кількість ігор у кожного користувача магазину
```SQL
SELECT COUNT(*) AS purchases
FROM purchase
GROUP BY credential_id;
```
<img width="1150" height="225" alt="image" src="https://github.com/user-attachments/assets/0ed5bf1c-1a83-4aef-b216-eb3eb6f66eba" />

### Різні типи джоінів
#### Поєднання ім'я профілю та назви гри через покупку
```SQL
SELECT g.title, pf.name
FROM game g
JOIN purchase p on p.game_id = g.id
JOIN profile pf on p.credential_id = pf.credential_id
```
<img width="1142" height="138" alt="image" src="https://github.com/user-attachments/assets/7b78fe97-e253-49da-b281-86d465570577" />

#### Поєднання назв ігор, імен профілів і відгуків про гру
```SQL
SELECT g.title, pf.name, r.words
FROM game g
JOIN review r on r.game_id = g.id
JOIN profile pf on r.profile_id = pf.id;
```
<img width="1151" height="136" alt="image" src="https://github.com/user-attachments/assets/9371ba8a-c87e-4ae0-a336-11acdc778da7" />

#### Лише ігри без відгуків 
```SQL
SELECT g.title, r
FROM game g
LEFT JOIN review r ON g.id = r.game_id
WHERE r is NULL;
```
<img width="1150" height="209" alt="image" src="https://github.com/user-attachments/assets/8f6f0f58-bdf5-45be-999e-c61ef721a7da" />

### Використання підзапитів
#### Ігри дорожче середнього
```SQL
SELECT * FROM game
WHERE price::numeric > (SELECT AVG(price::numeric) FROM game);
```
<img width="773" height="104" alt="image" src="https://github.com/user-attachments/assets/50896c85-90d4-4ebd-b846-0530a5eb0803" />

#### Користувачи що залишали якісь відгуки
```SQL
SELECT name
FROM profile WHERE (SELECT COUNT(*) FROM review) > 0;
```
<img width="1162" height="216" alt="image" src="https://github.com/user-attachments/assets/4da6c755-fa22-4293-a117-aab1242be6de" />

#### Ігри де досягнень більше за 1
```SQL
SELECT g.title, a.title FROM game g
JOIN achievement a ON a.game_id = g.id
WHERE (SELECT COUNT(*) FROM achievement) > 1
```
<img width="1146" height="120" alt="image" src="https://github.com/user-attachments/assets/96a5ba3a-1057-4644-a549-3c9e9af4a787" />

### [queries.sql](./queries.sql)

## Висновок
Ми розібралися із аналітичними SQL-запити (`OLAP`), навчилися ними користуватися. В роботі ми продемострували роботу із агрегатними функціями, поєднаннями та підзапитами.


