
-- task 1
SELECT round(avg(orders_count), 2) orders_avg
FROM   (SELECT user_id,
               count(order_id) orders_count
        FROM   user_actions
        WHERE  action = 'create_order'
        GROUP BY user_id) _


-- task 2
with tt as (SELECT user_id,
                   count(order_id) orders_count
            FROM   user_actions
            WHERE  action = 'create_order'
            GROUP BY user_id)
SELECT round(avg(orders_count), 2) orders_avg
FROM tt


-- task 3
SELECT *
FROM   products
WHERE  price != (SELECT min(price)
                 FROM   products)
ORDER BY product_id desc


-- task 4
SELECT *
FROM   products
WHERE  price > (SELECT avg(price)
                FROM   products) + 20
ORDER BY product_id desc


-- task 5
SELECT count(distinct user_id) users_count
FROM   user_actions
WHERE  action = 'create_order'
   and time > (SELECT max(time)
            FROM   user_actions) - interval '1 week'


-- task 6
SELECT age((SELECT max(time)
            FROM   courier_actions)::date, max(birth_date))::varchar min_age
FROM   couriers
WHERE  sex = 'male'
GROUP BY sex


-- task 7
SELECT order_id
FROM   user_actions
WHERE  order_id not in (SELECT DISTINCT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY order_id limit 1000


-- task 8
with norder as (SELECT user_id,
                       count(order_id) orders_count
                FROM   user_actions
                WHERE  action = 'create_order'
                GROUP BY user_id)
SELECT user_id,
       orders_count,
       (SELECT round(avg(orders_count), 2)
 FROM   norder) orders_avg, orders_count - (SELECT round(avg(orders_count), 2)
                                           FROM   norder) orders_diff
FROM   norder
ORDER BY user_id limit 1000


-- task 9
SELECT order_id,
       product_ids
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   courier_actions
                    WHERE  action = 'deliver_order'
                    ORDER BY time desc limit 100)
ORDER BY order_id


-- task 10
with _ as(SELECT courier_id
          FROM   courier_actions
          WHERE  action = 'deliver_order'
             and date_part('month', time) = 9
          GROUP BY courier_id having count(order_id) >= 30)
SELECT *
FROM   couriers
WHERE  courier_id in (SELECT *
                      FROM   _)
ORDER BY courier_id


-- task 11
with avgp as(SELECT round(avg(price), 2)
             FROM   products)
SELECT product_id,
       name,
       price,
       case when price - (SELECT *
                   FROM   avgp) >= 50 then price*0.85 when (SELECT *
                                         FROM   avgp) - price >= 50 then price*0.9 else price end as new_price
FROM   products
ORDER BY price desc, product_id


-- task 12
SELECT creation_time,
       order_id,
       product_ids,
       unnest(product_ids) product_id
FROM   orders limit 100


-- task 13
SELECT unnest(product_ids) product_id,
       count(*) times_purchased
FROM   orders
GROUP BY product_id
ORDER BY times_purchased desc limit 10


-- task 14
SELECT DISTINCT order_id,
                product_ids
FROM   (SELECT order_id,
               product_ids,
               unnest(product_ids) product_id
        FROM   orders) _
WHERE  product_id in(SELECT product_id
                     FROM   products
                     ORDER BY price desc limit 5)
ORDER BY order_id


-- task 15
with _ as(SELECT user_id,
                 date_part('year', age((SELECT max(time)
                                 FROM   user_actions), birth_date)) as ages
          FROM   users)
SELECT user_id,
       coalesce(ages, (SELECT round(avg(ages))
                FROM   _)) as age
FROM   _
ORDER BY user_id

