
-- task 1
SELECT sex,
       count(courier_id) couriers_count
FROM   couriers
GROUP BY sex
ORDER BY (count(courier_id))


-- task 2
SELECT sex,
       date_part('year', age(min(birth_date))) max_age
FROM   users
GROUP BY sex
ORDER BY max_age


-- task 3
SELECT date_part('year', age((birth_date))) age,
       count(1) users_count
FROM   users
GROUP BY 1
ORDER BY 1


-- task 4
SELECT date_part('year', age((birth_date))) age,
       sex,
       count(1) users_count
FROM   users
WHERE  birth_date is not null
GROUP BY age, sex
ORDER BY age, sex


-- task 5
SELECT date_trunc('month', time) as month,
       action,
       count(order_id) orders_count
FROM   user_actions
GROUP BY month, action


-- task 6
SELECT array_length(product_ids, 1) as order_size,
       count(order_id) as orders_count
FROM   orders
GROUP BY order_size
ORDER BY order_size


-- task 7
SELECT array_length(product_ids, 1) order_size,
       count(order_id) orders_count
FROM   orders
GROUP BY order_size having count(order_id) > 5000
ORDER BY order_size


-- task 8
SELECT courier_id,
       count(order_id) delivered_orders
FROM   courier_actions
WHERE  date_part('month', time) = 8
   and date_part('year', time) = 2022
   and action = 'deliver_order'
GROUP BY courier_id
ORDER BY delivered_orders desc limit 3


-- task 9
SELECT courier_id,
       count(order_id) delivered_orders
FROM   courier_actions
WHERE  date_part('month', time) = 9
   and action = 'deliver_order'
GROUP BY courier_id having count(order_id) = 1
ORDER BY courier_id


-- task 10
SELECT user_id
FROM   user_actions
WHERE  action = 'create_order'
GROUP BY user_id having max(time) < '2022-09-08'
ORDER BY user_id


-- task 11
SELECT user_id,
       round(count(distinct order_id) filter(WHERE action = 'cancel_order')::decimal / count(distinct order_id)::decimal,
             2) cancel_rate
FROM   user_actions
GROUP BY user_id
ORDER BY user_id


-- task 12
SELECT case when date_part('year', age(birth_date)) between 19 and
                 24 then '19-24'
            when date_part('year', age(birth_date)) between 25 and
                 29 then '25-29'
            when date_part('year', age(birth_date)) between 30 and
                 35 then '30-35'
            when date_part('year', age(birth_date)) between 36 and
                 41 then '36-41' end as group_age,
       count(user_id) as users_count
FROM   users
WHERE  birth_date is not null
GROUP BY group_age
ORDER BY group_age	