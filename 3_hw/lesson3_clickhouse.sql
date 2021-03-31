-- запрос 1
-- таблица с заказами
select *
from data_analysis.orders
limit 10;

-- таблица с калькуляциями (калькуляция - просмотр цены)
select *
from data_analysis.views
limit 10;


-- запрос 3, агрегатные функции
select tariff,
       uniqExact(idhash_view) as views,
       countIf(idhash_order,idhash_order > 0) as orders,
       orders/views  as View2Order
from data_analysis.views
group by tariff;

-- запрос 4 агрегатные функции ч2
select tariff,
       count(idhash_view) as total_views,
       uniqExact(idhash_view) as uniq_views,
       avgIf(client_bill_usd,client_bill_usd > 0) as average_bill,
       medianIf(client_bill_usd,client_bill_usd > 0) as median_bill,
       quantile(0.9)(client_bill_usd) as percentile_90_bill,
       quantileIf(0.9)(client_bill_usd,client_bill_usd > 0) as percentile_90_correct
from data_analysis.views
group by tariff;

-- запрос 5
-- работа с датой и временем
-- к началу 5 минутки
select toStartOfFiveMinute(now()) as inteval_5_min
union all
-- к началу 15 минутки
select toStartOfFifteenMinutes(now()) as interval_15_min
union all
-- начало часа
select toStartOfHour(now()) as interval_hour
union all
-- начало дня
select toStartOfDay(now()) as interval_day
union all
-- начало недели
select toStartOfWeek(now()) as interval_week
union all
-- начало месяца
select toStartOfMonth(now()) as interval_month
union all
-- начало года
select toStartOfYear(now()) as interval_year;


-- запрос 6
-- получаем часть даты
select view_dttm,
       toDate(view_dttm) as view_date,
       toYear(view_dttm) as view_year,
       toMonth(view_dttm) AS view_month,
       toYYYYMMDD(view_dttm),
       toHour(view_dttm) as view_hour,
       toDayOfWeek(view_dttm) as view_weekdate,
       toSecond(view_dttm) as view_second,
       toMinute(view_dttm) as view_minute
from data_analysis.views
limit 20;

-- запрос 7
-- сгруппируем заказы по 15мин
select toStartOfFifteenMinutes(order_dttm) as order_dttm15,
       uniqExact(idhash_order)             as orders
from data_analysis.orders
group by order_dttm15
order by order_dttm15
limit 100;

-- запрос 8
-- длительность заказов

select toStartOfFifteenMinutes(order_dttm)              as order_dttm15,
       uniqExact(idhash_order)                          as orders,
       avg(dateDiff('minute', order_dttm, finish_dttm)) as average_trip_duration
from data_analysis.orders
where status = 'CP'
group by order_dttm15
order by order_dttm15
limit 100;


-- запрос 9
-- условные конструкции

select if(cancel_dttm > 0, 'Отменил клиент', 'Не отменял')                as
           client_cancel,
       multiIf(cancel_dttm > 0 and da_dttm is null, 'До назначения',
               cancel_dttm > 0 and da_dttm > 0, 'После назначения', null) as
           when_cancel,
       uniqExact(idhash_order)                                            as
           orders
from data_analysis.orders
group by client_cancel, when_cancel;


-- запрос 10
-- максимальная разница между временем создания заказа по датам
SELECT order_date,
       max(runningDifference(order_dttm)) as diff
from (
      SELECT toDate(order_dttm) as order_date,
             order_dttm
      from data_analysis.orders
      order by order_dttm asc
         )
group by order_date;

-- запрос 11
-- тоже самое только с функцией neighbor()
select order_date,
       order_dttm,
       neighbor(order_dttm,1) as prev_dt,
       order_dttm - prev_dt as diff
from (
      SELECT toDate(order_dttm) as order_date,
             order_dttm
      from data_analysis.orders
      order by order_dttm desc
         );


-- запрос 12
-- работа с гео
-- гексагоны h3
select toStartOfHour(view_dttm)        as view_dttm_h,
       geoToH3(longitude, latitude, 7) as h3,
       uniqExact(idhash_view)          as views,
       uniqExact(idhash_order)         as orders
from data_analysis.views
group by view_dttm_h, h3;


