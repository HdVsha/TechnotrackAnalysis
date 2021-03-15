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

/*  3.
Получить идентификатор игрока и среднюю продолжительность
его матчей;
 */

select p.account_id,
       avg(m.duration) as average_match_duration
from match m
         join players p on m.match_id = p.match_id
group by p.account_id;

---

/*  4.
 Получить суммарное количество потраченного золота,
уникальное количество использованных персонажей, среднюю
продолжительность матчей (в которых участвовали данные
игроки) для анонимных игроков;
 */

