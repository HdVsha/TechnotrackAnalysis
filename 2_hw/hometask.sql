/*
Создадим вьюху с основной информацией и первым коэф-ом, чтобы пользоваться пользоваться ею на протяжении всей сессии. Потому что могу :D
*/

CREATE MATERIALIZED VIEW main_viez AS (
    SELECT account_id,
           pr.total_matches,
           pr.total_wins,
           CASE WHEN pr.total_matches > 0 THEN ROUND(pr.total_wins) / pr.total_matches ELSE pr.total_wins END AS win_coef
    FROM dota.players p
             INNER JOIN dota.player_ratings pr USING (account_id)
    WHERE account_id > 0
);

/*
Думаю, стоит проверить корректность
*/
SELECT * FROM main_viez;

/*
Теперь посчитаем второй коэф-т, используя cte
*/
WITH tmp_rating AS MATERIALIZED (
    SELECT account_id,
           mv.total_matches,
           mv.total_wins,
           mv.win_coef,
           p.kills,
           p.assists,
           AVG(p.gold_per_min) AS average_gold_per_minute,
           AVG(p.hero_healing) AS average_healing
    FROM dota.players p
    INNER JOIN main_viez mv USING(account_id)
    GROUP BY account_id, mv.total_matches, mv.total_wins, mv.win_coef, p.kills, p.assists
)
/*
 Выводим нашу таблицу
 */
SELECT *,
       usefulness_coef + win_coef as ratio,
       ROW_NUMBER() OVER ()
       FROM (
            SELECT account_id,
                   total_matches,
                   total_wins,
                   win_coef,
                   ROUND(kills + assists + average_gold_per_minute + average_healing) / 10000 AS usefulness_coef
            FROM tmp_rating) as tmp_table
        ORDER BY ratio DESC;