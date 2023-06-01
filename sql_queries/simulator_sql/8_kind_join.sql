
-- task 1
SELECT u.user_id user_id_left,
       u_.user_id user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   users u join user_actions u_ using(user_id)
ORDER BY 1


-- task 2
SELECT count(distinct user_id) users_count
FROM   users u join user_actions u_ using(user_id)


-- task 3
SELECT u_.user_id user_id_left,
       u.user_id user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions u_
    LEFT JOIN users u using(user_id)
ORDER BY user_id_left


-- task 4
SELECT count(distinct u_.user_id) users_count
FROM   user_actions u_
    LEFT JOIN users u using(user_id)


-- task 5
SELECT u_.user_id user_id_left,
       u.user_id user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions u_
    LEFT JOIN users u using(user_id)
WHERE  u.user_id is not null
ORDER BY user_id_left


-- task 6
SELECT u.birth_date users_birth_date,
       users_count,
       c.birth_date couriers_birth_date,
       couriers_count
FROM   (SELECT birth_date,
               count(user_id) as users_count
        FROM   users
        WHERE  birth_date is not null
        GROUP BY birth_date) u full join (SELECT birth_date,
                                         count(courier_id) as couriers_count
                                  FROM   couriers
                                  WHERE  birth_date is not null
                                  GROUP BY birth_date) c using (birth_date)
ORDER BY users_birth_date, couriers_birth_date


-- task 7
SELECT count(*) dates_count
FROM   (SELECT birth_date
        FROM   users
        WHERE  birth_date is not null
        UNION
SELECT birth_date
        FROM   couriers
        WHERE  birth_date is not null) _


-- task 8
SELECT user_id,
       name
FROM   (SELECT user_id
        FROM   users limit 100) u cross join products
ORDER BY user_id, name


-- task 9
SELECT user_id,
       order_id,
       product_ids
FROM   user_actions join orders using (order_id)
ORDER BY user_id, order_id limit 1000


-- task 10
SELECT DISTINCT user_id,
                order_id,
                product_ids product_ids
FROM   (SELECT user_id,
               order_id
        FROM   user_actions except
SELECT user_id,
               order_id
        FROM   user_actions
        WHERE  action = 'cancel_order') _ join orders using (order_id)
ORDER BY user_id, order_id limit 1000


-- task 11
SELECT user_id,
       round(avg(array_length(product_ids, 1)), 2) avg_order_size
FROM   (SELECT user_id,
               order_id
        FROM   user_actions except
SELECT user_id,
               order_id
        FROM   user_actions
        WHERE  action = 'cancel_order') _ join orders using (order_id)
GROUP BY user_id
ORDER BY user_id limit 1000


-- task 12
SELECT order_id,
       product_id,
       price
FROM   (SELECT order_id,
               unnest(product_ids) product_id
        FROM   orders) _ join products using(product_id)
ORDER BY order_id, product_id limit 1000


-- task 13
SELECT order_id,
       sum(price) order_price
FROM   (SELECT order_id,
               unnest(product_ids) product_id
        FROM   orders) _ join products using(product_id)
GROUP BY order_id
ORDER BY order_id limit 1000


-- task 14
SELECT user_id,
       count(user_id) orders_count,
       round(avg(order_size), 2) avg_order_size,
       sum(order_price) sum_order_value,
       round(avg(order_price), 2) avg_order_value,
       min(order_price) min_order_value,
       max(order_price) max_order_value
FROM   (SELECT user_id,
               order_id
        FROM   user_actions except
SELECT user_id,
               order_id
        FROM   user_actions
        WHERE  action = 'cancel_order') _ join (SELECT order_id,
                                               count(order_id) order_size,
                                               sum(price) order_price
                                        FROM   (SELECT order_id,
                                                       unnest(product_ids) product_id
                                                FROM   orders) __ join products using(product_id)
                                        GROUP BY order_id) __ using (order_id)
GROUP BY user_id
ORDER BY user_id limit 1000


-- task 15
SELECT name,
       count(product_id) times_purchased
FROM   (SELECT DISTINCT order_id,
                        unnest(product_ids) product_id
        FROM   orders)_
    LEFT JOIN products using (product_id)
    RIGHT JOIN courier_actions using (order_id)
WHERE  action = 'deliver_order'
   and date_part('month', time) = 9
GROUP BY name
ORDER BY times_purchased desc limit 10


-- task 16
SELECT coalesce(sex, 'unknown') sex,
       round(avg(cancel_rate), 3) avg_cancel_rate
FROM   (SELECT user_id,
               sex,
               count(distinct order_id) filter (WHERE action = 'cancel_order')::decimal / count(distinct order_id) cancel_rate
        FROM   user_actions
            LEFT JOIN users using(user_id)
        GROUP BY user_id, sex
        ORDER BY cancel_rate desc)_
GROUP BY sex
ORDER BY sex


-- task 17
SELECT order_id
FROM   (SELECT order_id,
               time
        FROM   courier_actions
        WHERE  action = 'deliver_order')_
    LEFT JOIN orders using(order_id)
ORDER BY age(time, creation_time) desc limit 10


-- task 18
SELECT order_id,
       array_agg(name) product_names
FROM   (SELECT order_id,
               unnest(product_ids) product_id
        FROM   orders)_
    LEFT JOIN products using (product_id)
GROUP BY order_id limit 1000


-- task 19
SELECT order_id,
       user_id,
       date_part('year', age((SELECT max(time)
                       FROM   user_actions)::date, u.birth_date)) user_age, courier_id, date_part('year', age((SELECT max(time)
                                                                                        FROM   user_actions)::date, 
                                                                                               c.birth_date)) courier_age
FROM   users u
    RIGHT JOIN user_actions ua using (user_id)
    RIGHT JOIN (SELECT order_id
                FROM   orders
                WHERE  array_length(product_ids, 1) = (SELECT max(array_length(product_ids, 1))
                                                       FROM   orders))_
    LEFT JOIN (SELECT *
               FROM   courier_actions
               WHERE  action = 'deliver_order') ca using(order_id) using(order_id)
    LEFT JOIN couriers c using(courier_id)
ORDER BY order_id


-- task 20
with couple_ as(SELECT DISTINCT order_id,
                                name
                FROM   (SELECT order_id,
                               unnest(product_ids) product_id FROM(SELECT *
                                                            FROM   orders
                                                            WHERE  order_id not in (SELECT order_id
                                                                                    FROM   user_actions
                                                                                    WHERE  action = 'cancel_order'))_)__ 
                                                                                    join products using(product_id))
SELECT DISTINCT array_agg(distinct part) pair,
                count(unsorted_pair) / 2 count_pair
FROM   (SELECT unsorted_pair,
               unnest(unsorted_pair) part
        FROM   (SELECT array[_.name,
                       __.name] unsorted_pair
                FROM   couple_ _
                    LEFT JOIN couple_ __ using(order_id)
                WHERE  _.name != __.name)_
        ORDER BY unsorted_pair, part)_
GROUP BY unsorted_pair
ORDER BY count_pair desc
