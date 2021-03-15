-- стандартный запрос
SELECT distinct account_id,
                kills  as total_kills,
                deaths as total_deaths,
                level
from players
where gold_spent > 0
  and kills between 1 and 20
  and (hero_id = 98 or hero_id = 111)
ORDER BY kills ASC, level DESC;


-- агрегатные функции

select avg(duration)          as average_match_duration
     , min(duration)          as min_match_duration
     , max(duration)          as max_match_duration
     , sum(duration)          as sum_matсh_duration

from match;

-- группировка
select game_mode,
       avg(duration) as average_match_duration,
       min(duration) as min_match_duration,
       max(duration) as max_match_duration,
       sum(duration) as sum_match_duration
from match
GROUP BY game_mode;

-- сделаем красиво (CASE)
select case when game_mode = 2 then 'Captains Mode' else 'Ranked Matchmaking' end as mode,
       round(avg(duration),2) as average_match_duration,
       min(duration) as min_match_duration,
       max(duration) as max_match_duration,
       sum(duration) as sum_match_duration
from match
GROUP BY mode;


-- группировка по 2м и более полям
select case
           when game_mode = 2
               then 'Captains Mode'
           else 'Ranked Matchmaking' end as mode,
       cluster,
       avg(duration)                     as average_match_duration
from match
GROUP BY game_mode, cluster;


-- having
select account_id,
       count(distinct hero_id) as number_of_heroes,
       sum(kills)              as total_kills,
       sum(deaths)             as total_deaths,
       min(gold_spent)         as minumum_gold_spent
from players
where account_id != 0
group by account_id
having count(match_id) > 1;


-- работа с несколькими таблицами
--- inner join
select reg.region,
       avg(m.duration) as average_match_duration,
       min(m.duration) as min_match_duration,
       max(m.duration) as max_match_duration,
       sum(m.duration) as sum_math_duration
from match m
         join cluster_regions reg on m.cluster = reg.cluster
group by reg.region;


-- left outer join
select pl.account_id, rat.total_wins, pl.gold, hn.localized_name
from players pl
         left join player_ratings rat on pl.account_id = rat.account_id
         left join hero_names hn on pl.hero_id = hn.hero_id
where pl.account_id > 0;

