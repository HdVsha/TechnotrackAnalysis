/*  1.
Посчитать количество матчей, в которых first_blood_time больше
1 минуты, но меньше 3х минут;
*/

SELECT COUNT(*) FROM match WHERE first_blood_time between 60 and 180;

---

/*  2.
 Вывести идентификаторы участников (исключая анонимные
аккаунты где айдишник равен нулю), которые участвовали в
матчах, в которых победили силы Света и количество
позитивных отзывов зрителей было больше чем количество
негативных;
 */

SELECT DISTINCT account_id
from players inner join match  -- because both tables have match_id
    using(match_id)
where   (match.radiant_win = 'True')
        and (account_id != 0)
        and (match.positive_votes > match.negative_votes)
ORDER BY account_id;

---
