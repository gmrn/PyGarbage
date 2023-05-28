
-- task 1
SELECT product_id,
       name,
       price
FROM   products
WHERE  price <= 100
ORDER BY product_id

-- task 2
SELECT user_id
FROM   users
WHERE  sex = 'female'
ORDER BY user_id limit 1000

-- task 3
SELECT user_id,
       order_id,
       time
FROM   user_actions
WHERE  time >= '2022.09.06'
   and action = 'create_order'
ORDER BY order_id

-- task 4
SELECT product_id,
       name,
       price as old_price,
       price*0.8 as new_price
FROM   products
WHERE  price*0.8 > 100
ORDER BY product_id

-- task 5
SELECT product_id,
       name
FROM   products
WHERE  length(name) = 5
    or split_part(name, ' ', 1) = 'чай'
GROUP BY product_id

-- task 6
SELECT product_id,
       name
FROM   products
WHERE  lower(name) like '%чай%'
ORDER BY product_id

-- task 7
SELECT product_id,
       name
FROM   products
WHERE  lower(name) like 'с%'
   and name not like '% %'
ORDER BY product_id

-- task 8
SELECT product_id,
       name,
       price,
       '25%' discount,
       price*0.75 new_price
FROM   products
WHERE  price > 60
   and name like '%чай %'
ORDER BY product_id

-- task 9
SELECT *
FROM   user_actions
WHERE  user_id in (170, 200, 230)
   and time between '2022.08.24'
   and '2022.09.05'
ORDER BY order_id desc

-- task 10
SELECT birth_date,
       courier_id,
       sex
FROM   couriers
WHERE  birth_date is null
ORDER BY courier_id

-- task 11
SELECT user_id,
       birth_date
FROM   users
WHERE  sex = 'male'
   and birth_date is not null
ORDER BY birth_date desc limit 50

-- task 12
SELECT order_id,
       time
FROM   courier_actions
WHERE  courier_id = 100
   and action = 'deliver_order'
ORDER BY time desc limit 10

-- task 13
SELECT order_id
FROM   user_actions
WHERE  date_part('year', time) = 2022
   and date_part('month', time) = 08
   and action = 'create_order'
ORDER BY order_id

-- task 14
SELECT courier_id
FROM   couriers
WHERE  date_part('year', birth_date) between 1990
   and 1995
ORDER BY courier_id

-- task 15
SELECT *
FROM   user_actions
WHERE  action = 'cancel_order'
   and date_part('year', time) = 2022
   and date_part('month', time) = 8
   and date_part('dow', time) = 3
   and date_part('hour', time) between 12
   and 15
ORDER BY order_id desc

-- task 16
SELECT *,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price/120*20, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price- price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price- price/120*20, 2) end as price_before_tax
FROM   products
ORDER BY price_before_tax desc, product_id
