# Частина 3
_Інтернет магазин ігор (альтернатива Steam)_

## SQL запити
### SELECT
#### Вибрати усі ігри
```SQL
SELECT * FROM game;
```
<img width="765" height="143" alt="image" src="https://github.com/user-attachments/assets/1229a464-cc0c-4efe-9282-567c99f596a4" />

---
#### Вибрати усі ігри дорожче 100
```SQL
SELECT * FROM game WHERE price > money(100);
```
<img width="767" height="95" alt="image" src="https://github.com/user-attachments/assets/58e02f48-5f48-425a-8d23-3859ecbd545d" />

---
#### Вибрати назви та опис профілів що володіють грою 2
```SQL
SELECT name, about FROM profile WHERE check_purchase_by_profile_and_game(id, 2);
```
<img width="736" height="150" alt="image" src="https://github.com/user-attachments/assets/399bd92b-0af5-4667-838f-2fb0c548a0eb" />

### INSERT
#### Додати нові студії
```SQL
INSERT INTO studio (id, title)
VALUES
  (6, 'Chigur game studio'),
  (7, 'Tupogubenky bichok');

SELECT * FROM studio WHERE id = 6 OR id = 7;
```
<img width="847" height="157" alt="image" src="https://github.com/user-attachments/assets/70254adc-ef7f-43d7-9507-628e2b5f285a" />

---
#### Додати нову гру (Оскільки гра обов'язково має мати файли, замість даних у прикладі використовуємо 0 bytea)
```SQL
INSERT INTO game (id, studio_id, publisher_id, title, price, data)
VALUES
  (5, 6, 7, 'Ya nikogo ne ubival', 600, '\x00000000'::bytea);

SELECT * FROM studio WHERE studio_id = 6;
```
<img width="760" height="133" alt="image" src="https://github.com/user-attachments/assets/7dab6d11-eec5-4483-920c-5abf29104b9c" />

### UPDATE
#### Збільшити ціну усіх ігор, чия вартісь менша за або довірнює 100, на 20. 
```SQL
-- Інфляція :(
UPDATE game
SET price = price + money(20)
WHERE price >= money(100);

SELECT * FROM game WHERE price <= money(120);
```
<img width="763" height="96" alt="image" src="https://github.com/user-attachments/assets/54811acb-96c8-4319-ba0e-10f94362e88f" />

### DELETE
#### Видалити студію, game, що посилаються на цю студію тим, чи іним чином(studio_id, publisher_id), видаляться каскадно :)
```SQL
DELETE FROM studio WHERE id = 6 OR id = 7;

SELECT * FROM studio;
SELECT * FROM game;
-- Ya nikogo ne ubival (гра) зникла із game, адже студію розробки та(або) видатниство видалили.
```
<img width="523" height="120" alt="image" src="https://github.com/user-attachments/assets/fb453313-bd3b-42d3-b3ed-9413358705d2" />
<img width="765" height="142" alt="image" src="https://github.com/user-attachments/assets/8bbaebd0-f7c0-47ba-8ab6-6056deaff2b9" />

## Висновок
_Ми потренувалися працювати із `SQL DML` у `PostgreSQL`, використовуючи оператори `SELECT`, `INSERT`, `UPDATE` та `DELETE`. Продемонсрували роботу цих методів на нашій `PostreSQL` БД._


