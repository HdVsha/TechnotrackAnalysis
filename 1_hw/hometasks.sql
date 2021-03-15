/*  1.
Посчитать количество матчей, в которых first_blood_time больше
1 минуты, но меньше 3х минут;
 */

SELECT COUNT(*)
FROM match
WHERE first_blood_time BETWEEN 60
          AND 180;

---

/*  2.
 Вывести идентификаторы участников (исключая анонимные
аккаунты где айдишник равен нулю), которые участвовали в
матчах, в которых победили силы Света и количество
позитивных отзывов зрителей было больше чем количество
негативных;
 */

SELECT DISTINCT account_id
FROM players
         INNER JOIN match -- because both tables have match_id
                    USING (match_id)
WHERE (match.radiant_win = 'True')
  AND (account_id != 0)
  AND (
    match.positive_votes > match.negative_votes
    )
ORDER BY account_id;

---

/*  3.
Получить идентификатор игрока и среднюю продолжительность
его матчей;
 */

SELECT p.account_id,
       AVG(m.duration) AS average_match_duration
FROM match m
         INNER JOIN players p ON m.match_id = p.match_id
GROUP BY p.account_id;

---

/*  4.
 Получить суммарное количество потраченного золота,
 количество уникальных использованных персонажей, среднюю
продолжительность матчей (в которых участвовали данные
игроки) для анонимных игроков;
 */

SELECT COUNT(distinct hero_id) AS num_unique_heroes,
       SUM(p.gold_spent)       AS sum_gold_spent,
       AVG(m.duration)         AS avg_match_duration
FROM match m
         INNER JOIN players p ON m.match_id = p.match_id
WHERE p.account_id = 0;

---

/*  5.
для каждого героя (hero_name) вывести: количество матчей в
которых был использован, среднее количество убийств,
минимальное количество смертей, максимальное количество
потраченного золота, суммарное количество позитивных
отзывов зрителей, суммарное количество негативных отзывов.
 */

SELECT hn.localized_name,
       COUNT(m.match_id)     AS count_matches,
       AVG(p.kills)          AS avg_kills,
       MIN(p.deaths)         AS min_deaths,
       MAX(p.gold_spent)     AS max_gold_spent,
       SUM(m.positive_votes) AS sum_positive_votes,
       SUM(m.negative_votes) AS sum_negative_votes
FROM players p
         INNER JOIN match m USING(match_id)
         INNER JOIN hero_names hn USING(hero_id)
GROUP BY hero_id;

---

/*  6.
вывести матчи в которых: хотя бы одна покупка item_id = 42
состоялась позднее 100 секунды с начала матча;
 */

SELECT pl.match_id -- number of lines = 49882
FROM purchase_log pl
WHERE (pl.item_id = 42)
  AND (pl.time > 100)
GROUP BY pl.match_id
HAVING COUNT(pl.item_id) > 0;

---

/*  7.
получить первые 20 строк из всех данных из таблиц с матчами и
оплатами (purchase_log);
 */

SELECT *
FROM match
    INNER JOIN purchase_log USING(match_id)
LIMIT 20;
