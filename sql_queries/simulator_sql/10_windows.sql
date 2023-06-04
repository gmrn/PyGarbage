
-- task 1
SELECT product_id,
       name,
       price,
       row_number() OVER (ORDER BY price desc) product_number,
       rank() OVER (ORDER BY price desc) product_rank,
       dense_rank() OVER (ORDER BY price desc) product_dense_rank
FROM   products


-- task 2
SELECT product_id,
       name,
       price,
       max(price) OVER () as max_price,
       round(price / max(price) OVER (), 2) as share_of_max
FROM   products
ORDER BY price desc, product_id


-- task 3
SELECT product_id,
       name,
       price,
       max(price) OVER (ORDER BY price desc) as max_price,
       min(price) OVER (ORDER BY price desc) as min_price
FROM   products
ORDER BY price desc, product_id


-- task 4
SELECT date,
       orders_count,
       sum(orders_count) OVER (ORDER BY date) as orders_cum_count
FROM   (SELECT date(creation_time) as date,
               count(order_id) as orders_count
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY date) t


-- task 5
SELECT user_id,
       order_id,
       time,
       row_number() OVER(PARTITION BY user_id
                         ORDER BY order_id) order_number
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id, order_number limit 1000


-- task 6
SELECT user_id,
       order_id,
       time,
       row_number() OVER (PARTITION BY user_id
                          ORDER BY time) as order_number,
       lag(time, 1) OVER (PARTITION BY user_id
                          ORDER BY time) as time_lag,
       time - lag(time, 1) OVER (PARTITION BY user_id
                                 ORDER BY time) as time_diff
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id, order_number limit 1000


-- task 7
SELECT user_id,
       round(extract(epoch
FROM   avg(time_diff)) / (60*60)) hours_between_orders
FROM   (SELECT user_id,
               time - lag(time) OVER (PARTITION BY user_id
                                      ORDER BY time) time_diff
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order'))_
GROUP BY user_id having round(extract(epoch
FROM   avg(time_diff)) / (60*60)) is not null limit 1000


-- task 8
SELECT date,
       orders_count,
       round(avg(orders_count) OVER (ORDER BY date rows between 3 preceding and 1 preceding),
             2) as moving_avg
FROM   (SELECT date(creation_time) as date,
               count(order_id) as orders_count
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY date) t


-- task 9
SELECT *,
       round(avg(delivered_orders) OVER (), 2) avg_delivered_orders,
       case when delivered_orders > avg(delivered_orders) OVER () then 1
            else 0 end as is_above_avg
FROM   (SELECT courier_id,
               count(courier_id) delivered_orders
        FROM   courier_actions
        WHERE  action = 'deliver_order'
           and date_part('month', time) = 9
        GROUP BY courier_id)_
ORDER BY courier_id


-- task 10
SELECT product_id,
       name,
       price,
       round(avg(price) OVER() , 2) avg_price,
       round(avg(price) filter(WHERE price != (SELECT max(price)
                                        FROM   products))
OVER(), 2) avg_price_filtered
FROM   products
ORDER BY price desc, product_id


-- task 11
SELECT *,
       round(canceled_orders / created_orders::decimal, 2) cancel_rate
FROM   (SELECT user_id,
               order_id,
               action,
               time,
               count(order_id) filter(WHERE action = 'create_order') OVER(PARTITION BY user_id
                                                                          ORDER BY time) created_orders,
               count(order_id) filter(WHERE action = 'cancel_order') OVER(PARTITION BY user_id
                                                                          ORDER BY time) canceled_orders
        FROM   user_actions)_
ORDER BY user_id, order_id, time limit 1000


-- task 12
SELECT *,
       row_number() OVER() courier_rank
FROM   (SELECT DISTINCT courier_id,
                        count(order_id) filter(WHERE action = 'deliver_order') OVER(PARTITION BY courier_id) orders_count
        FROM   courier_actions
        ORDER BY orders_count desc, courier_id)_ limit (SELECT count(distinct courier_id)*0.1
                                                FROM   courier_actions)


-- task 13
SELECT * FROM(SELECT DISTINCT courier_id,
                              max(date_part('day', (SELECT max(time)
                                    FROM   courier_actions) - time)) as days_employed, count(order_id) filter(
              WHERE  action = 'deliver_order') delivered_orders
              FROM   courier_actions
              GROUP BY courier_id)_
WHERE  days_employed >= 10
ORDER BY days_employed desc, courier_id


-- task 14
SELECT  *, sum(order_price) over(partition by creation_time::date) daily_revenue,
        round(order_price*100::decimal /
                sum(order_price) over(partition by creation_time::date), 3) percentage_of_daily_revenue
FROM( 
    SELECT  order_id,
            creation_time,
            sum(price) order_price
    FROM(
        SELECT  order_id,
                creation_time,
                unnest(product_ids) product_id
        FROM orders
        WHERE order_id not in(
                        SELECT order_id
                        FROM user_actions
                        WHERE action = 'cancel_order'))_
    left join products using(product_id)
    group by order_id, 
             creation_time)_
order by creation_time::date desc,
         percentage_of_daily_revenue desc,
         order_id


-- task 15
SELECT  *,
        COALESCE(daily_revenue - lag(daily_revenue, 1) over(), 0) as revenue_growth_abs,
        round(COALESCE((daily_revenue - lag(daily_revenue, 1) over())*100.0 
                            / lag(daily_revenue, 1) over(), 0), 1) revenue_growth_percentage
FROM(
    SELECT DISTINCT creation_time::date as date, 
    sum(order_price) over(partition by creation_time::date) daily_revenue
    FROM( 
        SELECT  order_id,
                creation_time,
                sum(price) order_price
        FROM(
            SELECT  order_id,
                    creation_time,
                    unnest(product_ids) product_id
            FROM orders
            WHERE order_id not in(
                            SELECT order_id
                            FROM user_actions
                            WHERE action = 'cancel_order'))_
        left join products using(product_id)
        group by order_id, 
                 creation_time)_
        order by date)_


-- task 16
with price_list as(
    SELECT  sum(price) order_price,
            row_number() over(order by sum(price)) rank,
            count(*) over() total
    FROM(
        SELECT  order_id,
                unnest(product_ids) product_id 
        FROM orders 
        WHERE order_id not in (
                        SELECT order_id 
                        FROM user_actions 
                        WHERE action = 'cancel_order'))_
    left join products using(product_id)
    group by order_id)

SELECT avg(order_price) as median_price
FROM price_list
WHERE rank BETWEEN total / 2.0 and total / 2.0 + 1
