# СИМУЛЯТОР SQL

[karpov.courses](https://lab.karpov.courses/learning/152/)

[Redash](https://redash.public.karpov.courses/)





## 4 Фильтрация данных

- [PostgreSQL WHERE](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-where/)
- [Collation Support](https://www.postgresql.org/docs/current/collation.html)
- [PostgreSQL LIKE](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-like/)
- [PostgreSQL IN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-in/)
- [PostgreSQL BETWEEN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-between/)
- [PostgreSQL IS NULL](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-is-null/)



**summary**

- Фильтрация данных и логические выражения в `WHERE`
- Шаблоны для текстовых значений с помощью оператора `LIKE`
- Операторы `IN`  и  `BETWEEN`
- `NULL` значения и `IS NULL`
- Даты, время и диапазоны значений
- Использование `CASE`

```sql
SELECT     -- перечисление полей результирующей таблицы
FROM       -- указание источника данных
WHERE      -- фильтрация данных
ORDER BY   -- сортировка результирующей таблицы
LIMIT      -- ограничение количества выводимых записей
```



[Practice](sql_queries/simulator_sql/4_filter.sql)

### LIMIT

```sql
-- task 2
SELECT user_id
FROM   users
WHERE  sex = 'female'
ORDER BY user_id limit 1000
```



### SPLIT_PART

```sql
-- task 5
SELECT product_id,
       name
FROM   products
WHERE  length(name) = 5
    or split_part(name, ' ', 1) = 'чай'
GROUP BY product_id
```



### LIKE

```sql
SELECT 'karpov.courses' LIKE 'karpov%'
-- true

SELECT 'karpov.courses' LIKE 'karpov_'
-- false

SELECT 'karpov.courses' LIKE '%karpov%'
-- true

SELECT 'karpov.courses' LIKE '_karpov%'
-- false

SELECT 'karpov.courses' LIKE '%.%'
-- true

SELECT 'karpov.courses' LIKE '_._'
-- false

SELECT 'karpov.courses' LIKE 'Karpov%'
-- false
```

```sql
-- task 6
SELECT product_id,
       name
FROM   products
WHERE  lower(name) like '%чай%'
ORDER BY product_id
```

```sql
-- task 7
SELECT product_id,
       name
FROM   products
WHERE  lower(name) like 'с%'
   and name not like '% %'
ORDER BY product_id
```



### BETWEEN, IN, desc

```sql
-- task 9
SELECT *
FROM   user_actions
WHERE  user_id in (170, 200, 230)
   and time between '2022.08.24'
   and '2022.09.05'
ORDER BY order_id desc
```



### DATE_PART

```sql
-- task 13
SELECT order_id
FROM   user_actions
WHERE  action = 'create_order'
   and date_part('month', time) = 8
   and date_part('year', time) = 2022
ORDER BY order_id
```

```sql
-- task 14
SELECT courier_id
FROM   couriers
WHERE  date_part('year', birth_date) between 1990
   and 1995
ORDER BY courier_id
```

```sql
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
```



### CASE, WHEN, THEN, END

```sql
-- task 16
SELECT product_id,
       name,
       price,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price/120*20, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price - price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price - price/120*20, 2) end as price_before_tax
FROM   products
ORDER BY price_before_tax desc, product_id
```





## 5 Агрегация данных

- [PostgreSQL SELECT DISTINCT](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-select-distinct/)
- [PostgreSQL Aggregate Functions](https://www.postgresqltutorial.com/postgresql-aggregate-functions/)
- [Aggregate Functions](https://www.postgresql.org/docs/9.5/functions-aggregate.html)
- [Array Functions and Operators](https://www.postgresql.org/docs/8.4/functions-array.html)



**summary**

- Поиск уникальных записей - ключевое слово `DISTINCT`

- Агрегирующие функции

- `COUNT(*)` и `COUNT(column)`.

- Фильтрация и агрегация в одном запросе

- Функция `array_length`

- Разница дат - функция `AGE`

- Агрегатные выражения с фильтрацией

  

[Practice](sql_queries/simulator_sql/5_aggregate.sql)

### DISTINCT

```sql
-- task 2
SELECT DISTINCT courier_id,
                order_id
FROM   courier_actions
ORDER BY courier_id, order_id
```

```sql
-- task 4
SELECT count(*) dates,
       count(birth_date) dates_not_null
FROM   users

```



### COUNT(*), COUNT(column1, column2...)

```sql
-- task 5
SELECT count(*) users,
       count(distinct user_id) unique_users
FROM   user_actions
```



### array_length

```sql
SELECT array_length(ARRAY[1,2,3], 1)
-- 3


--  _______
-- | 1 | 2 |
-- | 3 | 4 |
-- | 5 | 6 |
-- ‾‾‾‾‾‾‾

SELECT array_length(ARRAY[[1,2], [3,4], [5,6]], 1)
-- 3

SELECT array_length(ARRAY[[1,2], [3,4], [5,6]], 2)
-- 2
```

```sql
-- task 9
SELECT count(product_ids) orders
FROM   orders
WHERE  array_length(product_ids, 1) = 9
```



### AGE, current_date

```sql
SELECT AGE('2022-12-12', '2021-11-10')
-- 397 days, 0:00:00

SELECT current_date

SELECT AGE(current_date, '2021-11-10') 
SELECT AGE('2021-11-10') -- same before


SELECT AGE(current_date, '2021-11-10')::VARCHAR
-- 1 year 1 mon 2 days
```

```sql
-- task 13
select age(max(birth_date), min(birth_date))::VARCHAR age_diff
from users
where sex='male'
```



```sql
-- task 11
SELECT sum(case when name = 'сухарики' then price * 3
                when name = 'чипсы' then price * 2
                when name = 'энергетический напиток' then price
                else 0 end) as order_price
FROM   products
```

```sql
-- task 14
SELECT round(avg(array_length(product_ids, 1)), 2) avg_order_size
FROM   orders
WHERE  date_part('dow', creation_time) in (6, 0)
```



### FILTER

```sql
-- task 16
select count(DISTINCT user_id) - count(DISTINCT user_id) filter(where action = 'cancel_order') users_count

from user_actions
```

```sql
-- task 17
SELECT count(*) orders,
       count(*) filter(WHERE array_length(product_ids, 1) >= 5) large_orders,
       round(count(*) filter(WHERE array_length(product_ids, 1) >= 5) / count(*)::decimal,
             2)large_orders_share
FROM   orders
```

