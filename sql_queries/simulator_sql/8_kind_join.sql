
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
-- task 13
-- task 14
-- task 15
-- task 16
-- task 17
-- task 18
-- task 19
-- task 20