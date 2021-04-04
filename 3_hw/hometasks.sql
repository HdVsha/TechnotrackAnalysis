/* 1.

Построить по каждому тарифу воронку (посчитать кол-во
на всех этапах) от просмотра цены, до успешной поездки
– каждый шаг, отдельное поле. Напишите на каких 2 шагах
теряем больше всего клиентов? (Воронка: просмотр
цены – заказ – водитель назначен – машина подана –
клиент сел – успешная поездка)

 */

SELECT tariff,
       count(idhash_view) AS views_count,
       count(idhash_order) AS orders_count,
       count(da_dttm) AS driverAssigned_count,
       count(rfc_dttm) AS carCome_count,
       count(cc_dttm) AS clientSit_count,
       countIf(status, status = 'CP') AS successfulTrips_count
FROM views v
    JOIN orders o
    ON v.idhash_order = o.idhash_order
GROUP BY tariff;

-- Ответ: теряем больше всего, когда приписывается водитель(видимо клиенты отменяют заказ по какой-то причине),
-- и когда приезжает машина(возможно, слишком долго едет или клиент передумывает)

---

/* 2.

По каждому клиенту вывести топ используемых им
тарифов по убыванию в массиве, а также подсчитать
сколькими тарифами он пользуется.

 */

SELECT idhash_client,
       arraySort((x, y) -> -y,
           sumMap(tariffs_arr, arrayResize(CAST([], 'Array(UInt64)'), length(tariffs_arr), toUInt64(1))).1 AS tariff_arr,
           sumMap(tariffs_arr, arrayResize(CAST([], 'Array(UInt64)'), length(tariffs_arr), toUInt64(1))).2 AS tariff_occurence_arr)
            AS tariff_usage_top,
       length(tariff_usage_top) as number_of_tariffs_using
FROM (
    SELECT
        idhash_client,
        groupArray(tariff) AS tariffs_arr
    FROM views v
    GROUP BY idhash_client
)
GROUP BY idhash_client;

-- Explanation:
    -- first = [1,2,3,3,4,5]
    -- second = [1,1,1,1,1,1]
    -- sumMap(first,second) -> ([1,2,3,4,5], [1,1,2,1,1])

---

/* 3.

Вывести топ 10 гексагонов (размер 7) из которых уезжают
с 7 до 10 утра и в которые едут с 18-00 до 20-00 в сумме
по всем дням
(Don't know how to compare hours :( )
 */
SELECT
    geoToH3(longitude, latitude, 7) as h3,
    toStartOfHour(cc_dttm) as leave_time,
    toStartOfHour(finish_dttm) as come_time,
    count(h3) as h3_num
FROM views v JOIN orders o on v.idhash_order = o.idhash_order
WHERE (leave_time is not null) AND (come_time is not null)
GROUP BY h3, leave_time, come_time
ORDER BY h3_num DESC
LIMIT 10;

---

/* 4.

Вывести медиану и 95 квантиль времени поиска
водителя.

 */

SELECT
    idhash_order,
    dateDiff('minute', order_dttm, da_dttm) as driver_search_time,
    median(driver_search_time) as median,
    quantile(0.95)(driver_search_time) as quantile
FROM orders o
WHERE (order_dttm is not null) AND (da_dttm is not null)
GROUP BY  idhash_order, order_dttm, da_dttm