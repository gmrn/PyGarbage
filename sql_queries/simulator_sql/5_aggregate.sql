
-- task 1
SELECT DISTINCT user_id
FROM   user_actions
ORDER BY user_id


-- task 2
SELECT DISTINCT courier_id,
                order_id
FROM   courier_actions
ORDER BY courier_id, order_id


-- task 3
SELECT max(price) max_price,
       min(price) min_price
FROM   products


-- task 4
SELECT count(*) dates,
       count(birth_date) dates_not_null
FROM   users


-- task 5
SELECT count(*) users,
       count(distinct user_id) unique_users
FROM   user_actions


-- task 6
SELECT count(courier_id) couriers
FROM   couriers
WHERE  sex = 'female'


-- task 7
SELECT min(time) first_delivery,
       max(time) last_delivery
FROM   courier_actions
WHERE  action = 'deliver_order'


-- task 8
SELECT sum(price) order_price
FROM   products
WHERE  name in ('сухарики', 'чипсы', 'энергетический напиток')


-- task 9
SELECT count(product_ids) orders
FROM   orders
WHERE  array_length(product_ids, 1) = 9


-- task 10
SELECT age(max(birth_date))::varchar min_age
FROM   couriers
WHERE  sex = 'male'


-- task 11
SELECT sum(case when name = 'сухарики' then price*3
                when name = 'чипсы' then price*2
                when name = 'энергетический напиток' then price end) order_price
FROM   products


-- task 12
SELECT round(avg(price), 2) avg_price
FROM   products
WHERE  name like 'чай %'
    or name like 'кофе %'


-- task 13
SELECT age(max(birth_date), min(birth_date))::varchar age_diff
FROM   users
WHERE  sex = 'male'


-- task 14
SELECT round(avg(array_length(product_ids, 1)), 2) avg_order_size
FROM   orders
WHERE  date_part('dow', creation_time) in (6, 0)


-- task 15
SELECT count(distinct user_id) unique_users,
       count(distinct order_id) unique_orders,
       round(count(distinct order_id)::decimal / count(distinct user_id),
             2) orders_per_user
FROM   user_actions


-- task 16
SELECT count(distinct user_id) - count(distinct user_id) filter(WHERE action = 'cancel_order') users_count
FROM   user_actions


-- task 17
SELECT count(*) orders,
       count(*) filter(WHERE array_length(product_ids, 1) >= 5) large_orders,
       round(count(*) filter(WHERE array_length(product_ids, 1) >= 5) / count(*)::decimal,
             2)large_orders_share
FROM   orders