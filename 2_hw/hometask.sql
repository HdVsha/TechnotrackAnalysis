-- with main_cte AS MATERIALIZED (
    SELECT COUNT(p.match_id),
            p.account_id,
            pr.total_wins,
            ROW_NUMBER() OVER (
            PARTITION BY p.account_id
            ORDER BY COUNT(p.match_id)
        ) AS smth
    FROM dota.players p
         INNER JOIN dota.player_ratings pr USING(account_id)
    WHERE
    account_id > 0;

-- SELECT  cte.account_it
-- FROM
--     players p
--     INNER JOIN match m USING(match_id)
--     INNER JOIN main_cte cte USING(account_id)
--
-- );