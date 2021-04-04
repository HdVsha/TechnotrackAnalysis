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
GROUP BY tariff

-- Ответ: теряем больше всего, когда приписывается водитель(видимо клиенты отменяют заказ по какой-то причине),
-- и когда приезжает машина(возможно, слишком долго едет или клиент передумывает)
