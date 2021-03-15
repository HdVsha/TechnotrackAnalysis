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
         inner join players p on m.match_id = p.match_id
group by p.account_id;

---

/*  4.
 Получить суммарное количество потраченного золота,
 количество уникальных использованных персонажей, среднюю
продолжительность матчей (в которых участвовали данные
игроки) для анонимных игроков;
 */

select count(DISTINCT hero_id) as num_unique_heroes,
       sum(p.gold_spent) as sum_gold_spent,
       avg(m.duration) as avg_match_duration
from match m
         inner join players p on m.match_id = p.match_id
where p.account_id = 0
group by account_id;

---

/*  5.
для каждого героя (hero_name) вывести: количество матчей в
которых был использован, среднее количество убийств,
минимальное количество смертей, максимальное количество
потраченного золота, суммарное количество позитивных
отзывов зрителей, суммарное количество негативных отзывов.
 */

select count(m.match_id),
       max(p.gold_spent) as max_gold_spent,
       sum(m.positive_votes) as sum_positive_votes,
       sum(m.negative_votes) as sum_negative_votes
from players p
    inner join match m on m.match_id = p.match_id
    inner join hero_names hn on hn.hero_id = p.hero_id
group by hn.hero_id;